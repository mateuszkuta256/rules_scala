load("//third_party/repositories:repositories.bzl", "repositories")

ARTIFACT_IDS = [
    "io_bazel_rules_scala_scala_parser_combinators",
]

def _non_module_deps_impl(ctx):
    repositories(for_artifact_ids = ARTIFACT_IDS, validate_scala_version = True)

non_module_deps = module_extension(implementation = _non_module_deps_impl)
