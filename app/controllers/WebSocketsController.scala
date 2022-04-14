package controllers

import akka.actor.{Actor, ActorRef, ActorSystem, Props}
import play.api.Logger
import play.api.libs.json.{JsValue, Json}
import play.api.libs.streams.ActorFlow
import play.api.mvc._

import javax.inject._

sealed trait AppEvent
final case class NextPhoto()                 extends AppEvent
final case class DeletePhoto()               extends AppEvent
final case class ShowPhoto(filePath: String) extends AppEvent

object SimpleWebSocketActor {
  def props(clientActorRef: ActorRef): Props = Props(new SimpleWebSocketActor(clientActorRef))
}

class SimpleWebSocketActor(clientActorRef: ActorRef) extends Actor {
  val logger: Logger = play.api.Logger(getClass)

  override def preStart: Unit =
    context.system.eventStream.subscribe(self, classOf[AppEvent])

  def receive: Receive = {
    case _: NextPhoto =>
      clientActorRef ! Json.parse(s"""{"type": "next"}""")
    case photo: ShowPhoto =>
      clientActorRef ! Json.parse(s"""{"type": "photo", "data": "${photo.filePath}"}""")
  }

  def getMessage(json: JsValue): String = (json \ "command").as[String]
}

@Singleton
class WebSocketsController @Inject() (cc: ControllerComponents)(implicit system: ActorSystem)
    extends AbstractController(cc) {
  val logger: Logger = play.api.Logger(getClass)

  def socket: WebSocket = WebSocket.accept[JsValue, JsValue] { _ =>
    ActorFlow.actorRef { actorRef =>
      SimpleWebSocketActor.props(actorRef)
    }
  }

}
