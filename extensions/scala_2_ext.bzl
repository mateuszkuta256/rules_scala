load("//third_party/repositories:repositories.bzl", "repository")

def _scala_2_deps_impl(ctx):
    repository(
        id = "org_scalameta_semanticdb_scalac",
        validate_scala_version = True
    )
    repository(
        id = "io_bazel_rules_scala_scala_reflect",
        validate_scala_version = True
    )

scala_2_deps = module_extension(implementation = _scala_2_deps_impl)
