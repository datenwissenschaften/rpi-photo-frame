package controllers

import org.mapdb.{DB, DBMaker, HTreeMap, Serializer}
import play.api.cache.AsyncCacheApi
import play.api.libs.json.{JsValue, Json}
import play.api.libs.ws._
import play.api.mvc._
import play.api.{Configuration, Logging}

import java.io.File
import javax.inject._
import scala.concurrent.duration.Duration
import scala.concurrent.{ExecutionContext, Future}
import scala.util.Random

@Singleton
class HomeController @Inject() (
    ws: WSClient,
    configuration: Configuration,
    cache: AsyncCacheApi,
    val controllerComponents: ControllerComponents
)(implicit ec: ExecutionContext)
    extends BaseController
    with Logging {

  val cacheExpiry: Duration = configuration.get[Duration]("weatherCache.expiry")
  val cacheKey: String      = "weatherCache.key"

  val db: DB = DBMaker
    .fileDB("/tmp/photo.db")
    .concurrencyDisable()
    .checksumHeaderBypass()
    .fileLockDisable()
    .make()
  val map: HTreeMap[String, String] = db.hashMap("photo", Serializer.STRING, Serializer.STRING).createOrOpen()

  def index(): Action[AnyContent] = Action { implicit request: Request[AnyContent] =>
    Ok(views.html.index())
  }

  def weather(): Action[AnyContent] =
    Action.async { implicit request: Request[AnyContent] =>
      val weatherData = cache
        .getOrElseUpdate[JsValue](cacheKey, cacheExpiry) {
          val futureResponse: Future[WSResponse] = for {
            ipify <- ws.url("https://api.ipify.org").get()
            location <- ws
              .url(f"http://api.ipstack.com/${ipify.body}")
              .addQueryStringParameters("access_key" -> configuration.get[String]("ipstack.access.key"))
              .addQueryStringParameters("format" -> "1")
              .get()
            darksky <- ws
              .url(
                f"https://api.darksky.net/forecast/${configuration.get[String]("darksky.access.key")}" +
                  f"/${(location.json \ "latitude").as[Double]},${(location.json \ "longitude").as[Double]}"
              )
              .addQueryStringParameters("lang" -> "de")
              .addQueryStringParameters("units" -> "si")
              .get()
          } yield darksky
          futureResponse.recover { case e: Exception =>
            // val exceptionData = Map("error" -> Seq(e.getMessage))
            // ws.url(exceptionUrl).post(exceptionData)
            Json.toJson(Map("currently" -> Map("temperature" -> "99.9", "icon" -> "day-cloudy")))
          }
          futureResponse.map { response =>
            response.json
          }
        }
      weatherData.map { response =>
        Ok(response.toString())
      }
    }

  def random(): String = {
    def getListOfFiles(dir: File): Seq[File]                   = dir.listFiles.filter(_.isFile).filter(_.getName.toLowerCase.endsWith(".jpg")).toSeq
    def getRandomElement(seq: Seq[File], random: Random): File = seq(random.nextInt(seq.length))
    getRandomElement(getListOfFiles(new File(configuration.get[String]("photo.folder"))), new Random).getName
  }

  def photo(photo: Option[String]): Action[AnyContent] = Action.async { implicit request: Request[AnyContent] =>
    logger.info(s"Photo: $photo")
    val width        = configuration.get[String]("photoFrame.width")
    val height       = configuration.get[String]("photoFrame.height")
    val masterIP     = configuration.get[String]("master.ip")
    val currentImage = photo.getOrElse(random())
    map.put("current.image", currentImage)
    logger.info(s"Current image: $currentImage")
    ws.url(f"http://${masterIP}:8888/unsafe/${width}x${height}" + f"/smart/$currentImage")
      .get()
      .map { response =>
        Ok(response.bodyAsBytes).as("image/jpeg")
      }
  }

}
