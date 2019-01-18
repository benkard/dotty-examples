val dottyVersion = "0.12.0-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Intersection Types",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1",

    scalaVersion := dottyVersion,
    scalacOptions += "-deprecation"
  )
