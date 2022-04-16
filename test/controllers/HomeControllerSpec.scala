package controllers

import org.scalatestplus.play._
import org.scalatestplus.play.guice._
import play.api.test._

import scala.concurrent.{ExecutionContext, ExecutionContextExecutor}

class HomeControllerSpec extends PlaySpec with GuiceOneAppPerTest with Injecting {

  implicit val ec: ExecutionContextExecutor = ExecutionContext.global

}
