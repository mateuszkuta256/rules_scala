load("@rules_java//java:defs.bzl", "java_binary", "java_library")
load("//scala/versions:versions.bzl", "sanitize_version")
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "extract_major_version", "extract_minor_version")

_SCALA_COMPILE_CLASSPATH_DEPS = {
    "2": [
        "@io_bazel_rules_scala_scala_compiler",
        "@io_bazel_rules_scala_scala_library",
        "@io_bazel_rules_scala_scala_reflect",
    ],
    "3": [
        "@io_bazel_rules_scala_scala_compiler",
        "@io_bazel_rules_scala_scala_library",
        "@io_bazel_rules_scala_scala_interfaces",
        "@io_bazel_rules_scala_scala_tasty_core",
        "@io_bazel_rules_scala_scala_asm",
        "@io_bazel_rules_scala_scala_library_2",
    ],
}

def scalac(scala_version, compile_classpath = None, append_version = True):
    scala_major_version = extract_major_version(scala_version)
    scala_minor_version = extract_minor_version(scala_version)
    compiler_deps = compile_classpath or _compiler_deps(scala_version, append_version)

    java_library(
        name = "scalac_reporter",
        srcs = _reporter_srcs(scala_major_version, scala_minor_version),
        deps = compiler_deps + [
            "@io_bazel_rules_scala//src/protobuf/io/bazel/rules_scala:diagnostics_java_proto",
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac/compileoptions",
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac/reporter:scala_deps_java_proto",
        ],
    )
    java_binary(
        name = "scalac",
        srcs = _scalac_srcs(scala_version),
        main_class = "io.bazel.rulesscala.scalac.ScalacWorker",
        visibility = ["//visibility:public"],
        javacopts = [
            "-source 1.8",
            "-target 1.8",
        ],
        deps = compiler_deps + [
            ":scalac_reporter",
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/io_utils",
            "@bazel_tools//src/main/protobuf:worker_protocol_java_proto",
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/jar",
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/worker",
            "@io_bazel_rules_scala//src/protobuf/io/bazel/rules_scala:diagnostics_java_proto",
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac/compileoptions",
        ],
    )

def _compiler_deps(scala_version, append_version):
    if append_version:
        suffix = "_" + sanitize_version(scala_version)
        return [dep + suffix for dep in _SCALA_COMPILE_CLASSPATH_DEPS[scala_version[0:1]]]
    else:
        return _SCALA_COMPILE_CLASSPATH_DEPS[scala_version[0:1]]

def _reporter_srcs(scala_major_version, scala_minor_version):
    if (scala_major_version == "2.11") or (scala_major_version == "2.12" and int(scala_minor_version) < 13):
        return [
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac/deps_tracking_reporter:before_2_12_13",
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac/reporter:before_2_12_13",
        ]
    elif (scala_major_version == "2.12" and int(scala_minor_version) >= 13) or (scala_major_version == "2.13" and int(scala_minor_version) < 12):
        return [
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac/deps_tracking_reporter:after_2_12_13_and_before_2_13_12",
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac/reporter:after_2_12_13_and_before_2_13_12",
        ]
    elif (scala_major_version == "2.13" and int(scala_minor_version) >= 12):
        return [
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac/deps_tracking_reporter:after_2_13_12",
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac/reporter:after_2_13_12",
        ]
    else:
        return [
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac/reporter:scala_3",
        ]

def _scalac_srcs(scala_version):
    if scala_version.startswith("2"):
        return ["@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac:scalac_2"]
    else:
        return ["@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac:scalac_3"]

def _source_jar(ctx):
    java_common.pack_sources(
        ctx.actions,
        sources = ctx.files.srcs,
        output_source_jar = ctx.outputs.outs,
        java_toolchain = ctx.toolchains["@bazel_tools//tools/jdk:toolchain_type"].java,
    )

source_jar = rule(
    implementation = _source_jar,
    attrs = {
        "srcs": attr.label_list(mandatory = True, allow_empty = False, allow_files = True),
        "outs": attr.output(mandatory = True),
    },
    toolchains = ["@bazel_tools//tools/jdk:toolchain_type"],
)
