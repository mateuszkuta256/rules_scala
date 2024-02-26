load("@rules_java//java:defs.bzl", "java_binary", "java_library")
load("//scala/versions:versions.bzl", "sanitize_version")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "extract_major_version", "extract_minor_version")

def setup_scalac():
    for scala_version in SCALA_VERSIONS:
        _scalac(scala_version)

def _scalac(scala_version):
    scala_major_version = extract_major_version(scala_version)
    scala_minor_version = extract_minor_version(scala_version)
    version_suffix = "_" + sanitize_version(scala_version)

    java_binary(
        name = "scalac" + version_suffix,
        srcs = _scalac_srcs(scala_version),
        main_class = "io.bazel.rulesscala.scalac.ScalacWorker",
        visibility = ["//visibility:public"],
        javacopts = [
            "-source 1.8",
            "-target 1.8",
        ],
        deps = [
            _reporter(scala_major_version, scala_minor_version),
            "//scala/private/toolchain_deps:scala_compile_classpath",
            "//src/java/io/bazel/rulesscala/io_utils",
            "@bazel_tools//src/main/protobuf:worker_protocol_java_proto",
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/jar",
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/worker",
            "@io_bazel_rules_scala//src/protobuf/io/bazel/rules_scala:diagnostics_java_proto",
            "//src/java/io/bazel/rulesscala/scalac/compileoptions",
        ],
    )

def _reporter(scala_major_version, scala_minor_version):
    if (scala_major_version == "2.11") or (scala_major_version == "2.12" and int(scala_minor_version) < 13):
        return "//src/java/io/bazel/rulesscala/scalac/reporter:reporter_before_2_12_13"
    elif (scala_major_version == "2.12" and int(scala_minor_version) >= 13) or (scala_major_version == "2.13" and int(scala_minor_version) < 12):
        return "//src/java/io/bazel/rulesscala/scalac/reporter:reporter_after_2_12_13_and_before_2_13_12"
    elif (scala_major_version == "2.13" and int(scala_minor_version) >= 12):
        return "//src/java/io/bazel/rulesscala/scalac/reporter:reporter_after_2_13_12"
    else:
        return "//src/java/io/bazel/rulesscala/scalac/reporter:reporter_3"

def _scalac_srcs(scala_version):
    return [
        "ReportableMainClass.java",
        "ScalacInvoker.java",
        "ScalacInvokerResults.java",
        "ScalacWorker.java",
    ] if scala_version.startswith("2") else [
        "ScalacInvoker3.java",
        "ScalacInvokerResults.java",
        "ScalacWorker.java",
    ]
