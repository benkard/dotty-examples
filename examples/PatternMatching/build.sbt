val dottyVersion = "0.12.0-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Pattern Matching",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    )
  )
