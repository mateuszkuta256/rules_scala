load("//third_party/repositories:repositories.bzl", "repository")

def _scala_3_1_deps_impl(ctx):
    repository(id = "io_bazel_rules_scala_scala_parallel_collections")

scala_3_1_deps = module_extension(implementation = _scala_3_1_deps_impl)
