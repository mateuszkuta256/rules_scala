load("@rules_java//java:defs.bzl", "java_import", "java_library")
load("//scala:scala.bzl", "declare_dep_providers", "setup_scala_toolchains")

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

_DICT = {
    "3.3.1": {
        "scala_compile_classpath": [
            "@io_bazel_rules_scala_scala_compiler",
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
        ],
        "scala_library_classpath": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
        ],
    },
}

setup_scala_toolchains(_DICT)

java_import(
    name = "bazel_test_runner_deploy",
    jars = ["@bazel_tools//tools/jdk:TestRunner_deploy.jar"],
    visibility = ["//visibility:public"],
)

java_library(
    name = "PlaceHolderClassToCreateEmptyJarForScalaImport",
    srcs = ["PlaceHolderClassToCreateEmptyJarForScalaImport.java"],
    visibility = ["//visibility:public"],
)

declare_dep_providers()
