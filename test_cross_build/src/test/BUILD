load("@io_bazel_rules_scala//scala:scala.bzl", "scala_test")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

[
    scala_test(
        name = "greeting_test_" + version,
        srcs = select(
            {
                "@io_bazel_rules_scala//scala/versions:2_11_12": [
                    "Greeting2Test.scala",
                ],
                "@io_bazel_rules_scala//scala/versions:2_12_18": [
                    "Greeting2Test.scala",
                ],
                "@io_bazel_rules_scala//scala/versions:2_13_12": [
                    "Greeting2Test.scala",
                ],
                "@io_bazel_rules_scala//scala/versions:3_2_1": [
                    "Greeting3Test.scala",
                ],
                "@io_bazel_rules_scala//scala/versions:3_3_1": [
                    "Greeting3Test.scala",
                ],
                "//conditions:default": [
                    "Greeting3.scala",
                ],
            },
        ),
        scala_version = version,
        deps = [
            "//src/main:greeting",
        ],
    )
    for version in SCALA_VERSIONS
]
