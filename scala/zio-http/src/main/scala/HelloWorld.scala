import zhttp.http._
import zhttp.service.Server
import zio._

object HelloWorld extends App {

  val app = Http.collect[Request] {
    case Method.GET -> Root => Response.ok
    case Method.POST -> Root / "user" => Response.ok
    case Method.GET -> Root / "user" / id => {
      Response.text(id)
    }
  }

  override def run(args: List[String]): URIO[zio.ZEnv, ExitCode] =
    Server.start(3000, app).exitCode

}