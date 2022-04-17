name := "rpi-photo-frame"
organization := "com.datenwissenschaften"

version := "1.6.0"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.13.8"

libraryDependencies += guice
libraryDependencies += ws
libraryDependencies += ehcache

libraryDependencies += "com.bot4s" %% "telegram-core" % "5.4.1"
libraryDependencies += "com.bot4s" %% "telegram-akka" % "5.4.1"

libraryDependencies += "org.mapdb" % "mapdb" % "3.0.8"

libraryDependencies += "org.scalatestplus.play" %% "scalatestplus-play" % "5.1.0" % Test
