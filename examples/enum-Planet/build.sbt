val dottyVersion = "0.19.0-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "enum-Planet",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8",
      "-feature" 
    ),

    // resolvers += "Maven Central Server" at "http://central.maven.org/maven2",

    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/com.novocode/junit-interface
      "com.novocode" % "junit-interface" % "0.11" % Test,
      // https://mvnrepository.com/artifact/org.scalacheck/scalacheck
      "org.scalacheck" % "scalacheck_2.13" % "1.14.0" % Test
    ),

    testOptions ++= Seq(
      Tests.Setup(() => println("Setup")),
      Tests.Cleanup(() => println("Cleanup")),
      Tests.Filter(s => s.endsWith("Test"))
    )
  )
