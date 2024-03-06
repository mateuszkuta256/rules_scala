load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

scala_library(
    name = "greeting",
    srcs = select(
        {
            "@io_bazel_rules_scala_config//:2_11_12": [
                "Greeting2.scala",
            ],
            "@io_bazel_rules_scala_config//:2_12_18": [
                "Greeting2.scala",
            ],
            "@io_bazel_rules_scala_config//:2_13_12": [
                "Greeting2.scala",
            ],
            "@io_bazel_rules_scala_config//:3_2_1": [
                "Greeting3.scala",
            ],
            "@io_bazel_rules_scala_config//:3_3_1": [
                "Greeting3.scala",
            ],
            "//conditions:default": [
                "Greeting3.scala",
            ],
        },
    ),
    visibility = ["//visibility:public"],
)
