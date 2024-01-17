load("//third_party/repositories:repositories.bzl", "repository")

def _scala_3_deps_impl(ctx):
    repository(
        id = "io_bazel_rules_scala_scala_interfaces",
        validate_scala_version = True
    )
    repository(
        id = "io_bazel_rules_scala_scala_tasty_core",
        validate_scala_version = True
    )
    repository(
        id = "io_bazel_rules_scala_scala_asm",
        validate_scala_version = True
    )
    repository(
        id = "io_bazel_rules_scala_scala_library_2",
        validate_scala_version = True
    )

scala_3_deps = module_extension(implementation = _scala_3_deps_impl)
