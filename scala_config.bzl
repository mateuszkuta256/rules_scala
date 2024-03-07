load("//scala:scala_cross_version.bzl", "extract_major_version", "extract_minor_version")
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "sanitize_version")

def _default_scala_version():
    """return the scala version for use in maven coordinates"""
    return "2.12.18"

def _validate_supported_scala_version(scala_major_version, scala_minor_version):
    if scala_major_version == "2.11" and int(scala_minor_version) != 12:
        fail("Scala version must be 2.11.12 to use compiler dependency tracking with 2.11.")
    if scala_major_version == "2.12" and int(scala_minor_version) < 1:
        fail("Scala version must be newer or equal to 2.12.1 to use compiler dependency tracking.")

def _config_setting(scala_version):
    return "\n".join([
        "config_setting(",
        "    name = \"{name}\",",
        "    flag_values = {{\":scala_version\": \"{version}\"}},",
        ")\n",
    ]).format(name = sanitize_version(scala_version), version = scala_version)

def _config_settings(scala_versions):
    settings = ""
    for scala_version in scala_versions:
        settings = settings + _config_setting(scala_version)
    return settings

def _store_config(repository_ctx):
    scala_version = repository_ctx.os.environ.get(
        "SCALA_VERSION",
        repository_ctx.attr.scala_version,
    )

    scala_versions = repository_ctx.attr.scala_versions if repository_ctx.attr.scala_versions != [] else [scala_version]

    enable_compiler_dependency_tracking = repository_ctx.os.environ.get(
        "ENABLE_COMPILER_DEPENDENCY_TRACKING",
        str(repository_ctx.attr.enable_compiler_dependency_tracking),
    )

    scala_major_version = extract_major_version(scala_version)

    scala_minor_version = extract_minor_version(scala_version)
    if enable_compiler_dependency_tracking == "True":
        _validate_supported_scala_version(scala_major_version, scala_minor_version)

    config_file_content = "\n".join([
        "SCALA_VERSION='" + scala_version + "'",
        "SCALA_VERSIONS=" + str(scala_versions),
        "SCALA_MAJOR_VERSION='" + scala_major_version + "'",
        "SCALA_MINOR_VERSION='" + scala_minor_version + "'",
        "ENABLE_COMPILER_DEPENDENCY_TRACKING=" + enable_compiler_dependency_tracking,
    ])

    build_file_content = "\n".join([
        "load(\"@bazel_skylib//rules:common_settings.bzl\", \"string_flag\")",
        "string_flag(",
        "    name = \"scala_version\",",
        "    build_setting_default = \"\",",
        "    values = {versions},",
        "    visibility = [\"//visibility:public\"],",
        ")",
        "{settings}",
    ]).format(versions = scala_versions + [""], settings = _config_settings(scala_versions))

    repository_ctx.file("config.bzl", config_file_content)
    repository_ctx.file("BUILD", build_file_content)

_config_repository = repository_rule(
    implementation = _store_config,
    attrs = {
        "scala_version": attr.string(
            mandatory = True,
        ),
        "scala_versions": attr.string_list(
            mandatory = True,
        ),
        "enable_compiler_dependency_tracking": attr.bool(
            mandatory = True,
        ),
    },
    environ = ["SCALA_VERSION", "ENABLE_COMPILER_DEPENDENCY_TRACKING"],
)

def scala_config(
        scala_version = _default_scala_version(),
        scala_versions = [],
        enable_compiler_dependency_tracking = False):
    _config_repository(
        name = "io_bazel_rules_scala_config",
        scala_version = scala_version,
        scala_versions = scala_versions,
        enable_compiler_dependency_tracking = enable_compiler_dependency_tracking,
    )
