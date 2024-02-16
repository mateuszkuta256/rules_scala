load("@io_bazel_rules_scala//scala:advanced_usage/scala.bzl", "make_scala_binary")

scala_2_11_binary = make_scala_binary(scala_version = "2.11.12")
scala_2_12_binary = make_scala_binary(scala_version = "2.12.18")
scala_2_13_binary = make_scala_binary(scala_version = "2.13.12")
scala_3_1_binary = make_scala_binary(scala_version = "3.1.0")
scala_3_2_binary = make_scala_binary(scala_version = "3.2.1")
scala_3_3_binary = make_scala_binary(scala_version = "3.3.1")
