val dottyVersion = "0.21.0-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "cdsexamples.Main",
    description := "sbt example project to build/run Scala 3 code",
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
      "org.scalacheck" % "scalacheck_2.13" % "1.14.3" % Test,
      // https://mvnrepository.com/artifact/org.scalatest/scalatest
      "org.scalatest" % "scalatest_2.13" % "3.1.0" % "test"
    ),

    testOptions ++= Seq(
      Tests.Setup(() => println("Setup JUnit tests")),
      Tests.Cleanup(() => println("Cleanup JUnit tests")),
      Tests.Filter(s => s.endsWith("Test"))
    ),

    // receive periodic notifications of tests that have been running longer than 120 seconds
	testOptions in Test += Tests.Argument(TestFrameworks.ScalaTest, "-W", "120", "60")
  )
