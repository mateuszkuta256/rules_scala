load("//third_party/repositories:repositories.bzl", "repository")
load(
    "@io_bazel_rules_scala//scala/private:macros/scala_repositories.bzl",
    _dt_patched_compiler_setup = "dt_patched_compiler_setup",
)

def _scala_deps_impl(ctx):
    _dt_patched_compiler_setup()
    repository(
        id = "io_bazel_rules_scala_scala_library",
        validate_scala_version = True
    )
    repository(
        id = "io_bazel_rules_scala_scala_compiler",
        validate_scala_version = True
    )
    repository(
        id = "io_bazel_rules_scala_scala_xml",
        validate_scala_version = True
    )
    repository(
        id = "io_bazel_rules_scala_scala_parser_combinators",
        validate_scala_version = True
    )

scala_deps = module_extension(implementation = _scala_deps_impl)
