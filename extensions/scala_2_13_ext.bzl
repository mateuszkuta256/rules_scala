load("//third_party/repositories:repositories.bzl", "repository")

def _scala_2_13_deps_impl(ctx):
    repository(id = "io_bazel_rules_scala_scala_parallel_collections")

scala_2_13_deps = module_extension(implementation = _scala_2_13_deps_impl)
