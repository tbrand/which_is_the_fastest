name := "server"
scalaVersion := "2.13.5"

lazy val `zio-http` = (project in file(".")).settings(
  libraryDependencies += "io.d11" %% "zhttp" % "1.0.0.0-RC13"
)

enablePlugins(JavaAppPackaging)
