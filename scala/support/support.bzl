load("//scala:scala.bzl", "scala_library")
load("//scala/versions:versions.bzl", "sanitize_version")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION", "SCALA_VERSIONS")
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "extract_major_version")

_SCALAC_OPTS = {
    "3.3": [
        "-deprecation:true",
        "-encoding",
        "UTF-8",
        "-feature",
        "-language:existentials",
        "-language:higherKinds",
        "-language:implicitConversions",
        "-unchecked",
        "-Xfatal-warnings",
    ],
    "3.2": [
        "-deprecation:true",
        "-encoding",
        "UTF-8",
        "-feature",
        "-language:existentials",
        "-language:higherKinds",
        "-language:implicitConversions",
        "-unchecked",
        "-Xfatal-warnings",
    ],
    "3.1": [
        "-deprecation:true",
        "-encoding",
        "UTF-8",
        "-feature",
        "-language:existentials",
        "-language:higherKinds",
        "-language:implicitConversions",
        "-unchecked",
        "-Xfatal-warnings",
    ],
    "2.13": [
        "-deprecation:true",
        "-encoding",
        "UTF-8",
        "-feature",
        "-language:existentials",
        "-language:higherKinds",
        "-language:implicitConversions",
        "-unchecked",
        "-Xfatal-warnings",
        "-Xlint",
        "-Ywarn-dead-code",
        "-Ywarn-numeric-widen",
        "-Ywarn-value-discard",
        "-Wunused:imports",
    ],
    "2.12": [
        "-deprecation:true",
        "-encoding",
        "UTF-8",
        "-feature",
        "-language:existentials",
        "-language:higherKinds",
        "-language:implicitConversions",
        "-unchecked",
        "-Xfatal-warnings",
        "-Xlint",
        "-Yno-adapted-args",
        "-Ywarn-dead-code",
        "-Ywarn-numeric-widen",
        "-Ywarn-value-discard",
        "-Xfuture",
        "-Ywarn-unused-import",
        "-Ypartial-unification",
    ],
    "2.11": [
        "-deprecation:true",
        "-encoding",
        "UTF-8",
        "-feature",
        "-language:existentials",
        "-language:higherKinds",
        "-language:implicitConversions",
        "-unchecked",
        "-Xfatal-warnings",
        "-Xlint",
        "-Yno-adapted-args",
        "-Ywarn-dead-code",
        "-Ywarn-numeric-widen",
        "-Ywarn-value-discard",
        "-Xfuture",
        "-Ywarn-unused-import",
        "-Ypartial-unification",
    ],
}

def test_reporters():
    _test_reporter("test_reporter", SCALA_VERSION)
    for scala_version in SCALA_VERSIONS:
        _test_reporter("test_reporter_" + sanitize_version(scala_version), scala_version)

def _test_reporter(name, scala_version):
    scala_library(
        name = name,
        srcs = ["JUnitXmlReporter.scala"],
        scalacopts = _SCALAC_OPTS[extract_major_version(scala_version)],
        visibility = ["//visibility:public"],
        deps = [
            "//scala/private/toolchain_deps:scala_xml",
            "//testing/toolchain:scalatest_classpath",
        ],
    )
