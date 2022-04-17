package controllers

import akka.Done
import akka.actor.ActorSystem
import akka.stream.Materializer
import akka.stream.scaladsl._
import akka.util.{ByteString, Timeout}
import cats.implicits.toFunctorOps
import com.bot4s.telegram.api.RequestHandler
import com.bot4s.telegram.api.declarative.Commands
import com.bot4s.telegram.clients.ScalajHttpClient
import com.bot4s.telegram.future.{Polling, TelegramBot}
import com.bot4s.telegram.methods._
import com.bot4s.telegram.models._
import org.mapdb.{DB, DBMaker, HTreeMap, Serializer}
import play.api.Configuration
import play.api.i18n.{Lang, Langs, MessagesApi}
import play.api.libs.ws.{WSClient, _}
import play.api.mvc.{Action, AnyContent, BaseController, ControllerComponents}

import java.util.concurrent.TimeUnit
import javax.inject.{Inject, Singleton}
import scala.concurrent.duration.FiniteDuration
import scala.concurrent.{ExecutionContext, Future}
import scala.util.Random

@Singleton
class TelegramController @Inject() (
    ws: WSClient,
    configuration: Configuration,
    langs: Langs,
    messagesApi: MessagesApi,
    val controllerComponents: ControllerComponents
)(implicit ec: ExecutionContext, mat: Materializer, system: ActorSystem)
    extends BaseController
    with TelegramBot
    with Polling
    with Commands[Future] {

  implicit val timeout: Timeout = Timeout(FiniteDuration(1, TimeUnit.SECONDS))

  val lang: Lang     = langs.availables.head
  val token: String  = configuration.get[String]("telegram.token")
  val pin: String    = configuration.get[String]("secret.pin")
  val folder: String = configuration.get[String]("photo.folder")

  val p: Package      = getClass.getPackage
  val name: String    = p.getImplementationTitle
  val version: String = p.getImplementationVersion

  val db: DB = DBMaker
    .fileDB(f"${configuration.get[String]("temp.dir")}telegram.db")
    .closeOnJvmShutdown()
    .checksumHeaderBypass()
    .make()
  val map: HTreeMap[String, String] = db.hashMap("telegram", Serializer.STRING, Serializer.STRING).createOrOpen()

  val photoDB: DB = DBMaker
    .fileDB(f"${configuration.get[String]("temp.dir")}photo.db")
    .concurrencyDisable()
    .checksumHeaderBypass()
    .fileLockDisable()
    .closeOnJvmShutdown()
    .make()
  val photoMap: HTreeMap[String, String] = photoDB.hashMap("photo", Serializer.STRING, Serializer.STRING).createOrOpen()

  override val client: RequestHandler[Future] = new ScalajHttpClient(token)
  val isRun: Future[Unit]                     = this.run()

  override def receiveMessage(msg: Message): Future[Unit] = {

    msg.text.fold(Future.successful(())) {
      case "/start" => msg.reply("bot.pin")
      case "/next" =>
        system.eventStream.publish(NextPhoto())
        msg.reply("bot.photo.next")
      case "/delete" =>
        new java.io.File(f"${folder}${photoMap.get("current.image")}").delete()
        system.eventStream.publish(NextPhoto())
        msg.reply("bot.photo.delete")
      case `pin` =>
        if (map.getOrDefault(f"workflow_${msg.from.get.id}", "") == "START") {
          map.put(f"workflow_${msg.from.get.id}", "SUCCESS")
          request(SendMessage(msg.source, messagesApi("bot.success")(lang))).void
        } else {
          request(SendMessage(msg.source, messagesApi("bot.enter.pin.error")(lang))).void
        }
      case _ => msg.reply("bot.error")
    }

    if (msg.photo.isDefined && map.getOrDefault(f"workflow_${msg.from.get.id}", "") == "SUCCESS") {
      msg.photo.fold(Future.successful(())) { photo =>
        {
          val maxPhoto = photo.maxBy(_.height)
          request(GetFile(maxPhoto.fileId)).flatMap { file =>
            downloadFile(
              f"https://api.telegram.org/file/bot${token}/${file.filePath.get}"
            ).map(_ => ())
          }
          request(SendMessage(msg.source, messagesApi("bot.photo.new")(lang))).void
        }
      }
    } else {
      Future.successful(())
    }

  }

  def downloadFile(url: String): Future[Done] = {
    val futureResponse: Future[WSResponse] = ws.url(url).withMethod("GET").stream()
    val filePath                           = f"${Random.alphanumeric.take(10).mkString}.jpg"
    val localFile                          = new java.io.File(f"${folder}${filePath}")
    futureResponse.flatMap { res =>
      val outputStream = java.nio.file.Files.newOutputStream(localFile.toPath)
      val sink = Sink.foreach[ByteString] { bytes =>
        outputStream.write(bytes.toArray)
      }
      system.eventStream.publish(ShowPhoto(filePath))
      res.bodyAsSource
        .runWith(sink)
        .andThen { case result =>
          outputStream.close()
          result.get
        }
    }
  }

  def index: Action[AnyContent] = Action {
    Ok("It works.")
  }

  implicit class MessageHandler(msg: Message) {
    def reply(reply: String): Future[Unit] = {
      if (map.getOrDefault(f"workflow_${msg.from.get.id}", "") == "SUCCESS") {
        request(SendMessage(msg.source, messagesApi(reply)(lang))).void
      } else {
        map.put(f"workflow_${msg.from.get.id}", "START")
        request(SendMessage(msg.source, messagesApi("bot.welcome")(lang) + f" - $name - $version")).void
      }
    }
  }

}
