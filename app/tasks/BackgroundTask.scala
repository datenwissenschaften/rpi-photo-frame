package tasks

import akka.Done
import akka.actor.ActorSystem
import akka.stream.Materializer
import akka.stream.scaladsl.Sink
import akka.util.ByteString
import play.api.inject._
import play.api.libs.json.JsValue
import play.api.libs.ws.{WSClient, WSResponse}
import play.api.{Configuration, Logger}

import javax.inject.Inject
import scala.concurrent.duration._
import scala.concurrent.{ExecutionContext, Future}
import scala.language.postfixOps
import scala.sys.process._

class TasksModule extends SimpleModule(bind[BackgroundTask].toSelf.eagerly())

class BackgroundTask @Inject() (actorSystem: ActorSystem, ws: WSClient, configuration: Configuration)(implicit
    executionContext: ExecutionContext,
    mat: Materializer
) {

  val logger: Logger         = play.api.Logger(getClass)
  val optDir: String         = configuration.get[String]("opt.dir")
  var isDownloading: Boolean = false

  actorSystem.scheduler.scheduleAtFixedRate(initialDelay = 1.seconds, interval = 10.seconds) { () =>
    val url = "https://api.github.com/repos/mtnfranke/rpi-photo-frame/releases/latest"
    ws.url(url).get().map { response =>
      val body    = response.body
      val json    = play.api.libs.json.Json.parse(body)
      val version = (json \ "tag_name").as[String]
      val release = f"$optDir/rpi-photo-frame-$version"
      val archive = f"$release.zip"
      if (!new java.io.File(archive).exists && !isDownloading) {
        isDownloading = true
        logger.info(f"New version available - $version")
        val downloadUrl = ((json \ "assets").as[List[JsValue]].head \ "browser_download_url").as[String]
        logger.debug(s"Download URL: $downloadUrl")
        downloadFile(downloadUrl, archive).map { _ =>
          isDownloading = false
          logger.info(f"Downloaded $archive")
        } recover { case e =>
          isDownloading = false
          logger.error(s"Failed to download $archive", e)
        }
      }
      if (!new java.io.File(release).exists && !isDownloading) {
        if (f"unzip $release -d $optDir".! == 0) {
          logger.info(f"Unzipped $release")
          f"rm $optDir/rpi-photo-frame".!
          f"ln -s $release $optDir/rpi-photo-frame".!
        } else {
          logger.error(s"Failed to install $release")
          f"rm $archive".!
        }
      }
    }
  }

  def downloadFile(url: String, archive: String): Future[Done] = {
    val futureResponse: Future[WSResponse] = ws.url(url).withMethod("GET").stream()
    futureResponse.flatMap { res =>
      val outputStream = java.nio.file.Files.newOutputStream(new java.io.File(archive).toPath)
      val sink = Sink.foreach[ByteString] { bytes =>
        outputStream.write(bytes.toArray)
      }
      res.bodyAsSource
        .runWith(sink)
        .andThen { case result =>
          outputStream.close()
          result.get
        }
    }
  }

}
