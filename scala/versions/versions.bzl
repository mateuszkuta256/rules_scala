load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "extract_major_version", "extract_minor_version")

def _scala_version_transition_impl(settings, attr):
    if attr.scala_version:
        return {"//scala/versions:scala_version": attr.scala_version}
    else:
        return {}

scala_version_transition = transition(
    implementation = _scala_version_transition_impl,
    inputs = [],
    outputs = ["//scala/versions:scala_version"],
)

def sanitize_version(scala_version):
    return scala_version.replace(".", "_")

def cross_build_attrs(scala_version):
    return {
        "scala_version": attr.string(default = scala_version or ""),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_scalac": attr.label(
            executable = True,
            cfg = "exec",
            default = Label(_scalac_label(scala_version)),
            allow_files = True,
        ),
    }

def _scalac_label(scala_version):
    if scala_version:
        major_version = extract_major_version(scala_version)
        minor_version = extract_minor_version(scala_version)
        if major_version.startswith("2.11") or (major_version.startswith("2.12") and int(minor_version) < 13):
            return "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac:scalac_before_2_12_13"
        if ((major_version.startswith("2.12") and int(minor_version) >= 13) or (major_version.startswith("2.13") and int(minor_version) < 12)):
            return "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac:scalac_after_2_12_13_and_before_2_13_12"
        if (major_version.startswith("2.13") and int(minor_version) >= 12):
            return "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac:scalac_after_2_13_12"
        if (major_version.startswith("3")):
            return "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac:scalac_3"
    return "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/scalac:scalac"
