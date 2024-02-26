load("@rules_java//java:defs.bzl", "java_binary")
load(
    "@io_bazel_rules_scala_config//:config.bzl",
    "ENABLE_COMPILER_DEPENDENCY_TRACKING",
    "SCALA_MAJOR_VERSION",
)

SCALAC_DEPS = [
    "//scala/private/toolchain_deps:scala_compile_classpath",
    "//src/java/io/bazel/rulesscala/io_utils",
    "@bazel_tools//src/main/protobuf:worker_protocol_java_proto",
    "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/jar",
    "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/worker",
    "@io_bazel_rules_scala//src/protobuf/io/bazel/rules_scala:diagnostics_java_proto",
    "//src/java/io/bazel/rulesscala/scalac/compileoptions",
]

DEP_REPORTING_DEPS = ["//third_party/dependency_analyzer/src/main/io/bazel/rulesscala/dependencyanalyzer/compiler:dep_reporting_compiler"] if ENABLE_COMPILER_DEPENDENCY_TRACKING and SCALA_MAJOR_VERSION.startswith("2") else []

java_binary(
    name = "scalac",
    srcs = [
        ":scalac_files",
    ],
    javacopts = [
        "-source 1.8",
        "-target 1.8",
    ],
    main_class = "io.bazel.rulesscala.scalac.ScalacWorker",
    visibility = ["//visibility:public"],
    deps = DEP_REPORTING_DEPS + SCALAC_DEPS + ["//src/java/io/bazel/rulesscala/scalac/reporter"],
)

java_binary(
    name = "scalac_bootstrap",
    srcs = [
        ":scalac_files",
    ],
    javacopts = [
        "-source 1.8",
        "-target 1.8",
    ],
    main_class = "io.bazel.rulesscala.scalac.ScalacWorker",
    visibility = ["//visibility:public"],
    deps = SCALAC_DEPS + ["//src/java/io/bazel/rulesscala/scalac/reporter"],
)

filegroup(
    name = "scalac_files",
    srcs = [
        "ScalacInvokerResults.java",
        "ScalacWorker.java",
    ] + (
        [
            "ScalacInvoker.java",
            "ReportableMainClass.java",
        ] if SCALA_MAJOR_VERSION.startswith("2") else ["ScalacInvoker3.java"]
    ),
    visibility = ["//visibility:public"],
)

load("//src/java/io/bazel/rulesscala/scalac:scalac.bzl", "setup_scalac")

setup_scalac()
