load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_build_tools_release = "5.1.0"

def _ci_tools_dep_impl(ctx):
    http_archive(
        name = "bazelci_rules",
        sha256 = "eca21884e6f66a88c358e580fd67a6b148d30ab57b1680f62a96c00f9bc6a07e",
        strip_prefix = "bazelci_rules-1.0.0",
        url = "https://github.com/bazelbuild/continuous-integration/releases/download/rules-1.0.0/bazelci_rules-1.0.0.tar.gz",
    )
    http_archive(
        name = "com_github_bazelbuild_buildtools",
        sha256 = "e3bb0dc8b0274ea1aca75f1f8c0c835adbe589708ea89bf698069d0790701ea3",
        strip_prefix = "buildtools-%s" % _build_tools_release,
        url = "https://github.com/bazelbuild/buildtools/archive/%s.tar.gz" % _build_tools_release,
    )

ci_tools_dep = module_extension(implementation = _ci_tools_dep_impl)
