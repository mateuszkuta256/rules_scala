load("//scala/versions:versions.bzl", "sanitize_version")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

def _scala_runtime_impl(repository_ctx):
    build = """
load("@io_bazel_rules_scala//scala:bootstrap.bzl", "scalac")
scalac("{scala_version}")

load("@io_bazel_rules_scala//scala:scala.bzl", "setup_additional_toolchain")
setup_additional_toolchain(
    parser_combinators_deps = {parser_combinators_deps},
    scala_compile_classpath = {scala_compile_classpath},
    scala_library_classpath = {scala_library_classpath},
    scala_macro_classpath = {scala_macro_classpath},
    scala_xml_deps = {scala_xml_deps},
    semanticdb_deps = {semanticdb_deps},
    scala_version = "{scala_version}",
)
""".format(
        scala_version = repository_ctx.attr.scala_version,
        parser_combinators_deps = repository_ctx.attr.parser_combinators_deps or None,
        scala_compile_classpath = repository_ctx.attr.scala_compile_classpath or None,
        scala_library_classpath = repository_ctx.attr.scala_library_classpath or None,
        scala_macro_classpath = repository_ctx.attr.scala_macro_classpath or None,
        scala_xml_deps = repository_ctx.attr.scala_xml_deps or None,
        semanticdb_deps = repository_ctx.attr.semanticdb_deps or None,
    )
    repository_ctx.file("BUILD", build)

_scala_runtime = repository_rule(
    _scala_runtime_impl,
    attrs = {
        "scala_version": attr.string(),
        "parser_combinators_deps": attr.string_list(),
        "scala_compile_classpath": attr.string_list(),
        "scala_library_classpath": attr.string_list(),
        "scala_macro_classpath": attr.string_list(),
        "scala_xml_deps": attr.string_list(),
        "semanticdb_deps": attr.string_list(),
    },
)

def register_additional_scala_toolchain(
        scala_version,
        parser_combinators_deps = None,
        scala_compile_classpath = None,
        scala_library_classpath = None,
        scala_macro_classpath = None,
        scala_xml_deps = None,
        semanticdb_deps = None):
    _scala_runtime(
        name = "scala_" + sanitize_version(scala_version),
        scala_version = scala_version,
        parser_combinators_deps = parser_combinators_deps,
        scala_compile_classpath = scala_compile_classpath,
        scala_library_classpath = scala_library_classpath,
        scala_macro_classpath = scala_macro_classpath,
        scala_xml_deps = scala_xml_deps,
        semanticdb_deps = semanticdb_deps,
    )

def register_additional_scala_toolchains():
    for scala_version in SCALA_VERSIONS:
        register_additional_scala_toolchain(scala_version)
