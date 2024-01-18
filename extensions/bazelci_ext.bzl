load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _bazelci_dep_impl(ctx):
    http_archive(
        name = "bazelci_rules",
        sha256 = "eca21884e6f66a88c358e580fd67a6b148d30ab57b1680f62a96c00f9bc6a07e",
        strip_prefix = "bazelci_rules-1.0.0",
        url = "https://github.com/bazelbuild/continuous-integration/releases/download/rules-1.0.0/bazelci_rules-1.0.0.tar.gz",
    )

bazelci_dep = module_extension(implementation = _bazelci_dep_impl)
