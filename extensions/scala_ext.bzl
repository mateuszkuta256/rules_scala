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
    repository(
        id = "io_bazel_rules_scala_org_openjdk_jmh_jmh_core",
        fetch_sources = False,
    )
    repository(
        id = "io_bazel_rules_scala_org_openjdk_jmh_jmh_generator_asm",
        fetch_sources = False,
    )
    repository(
        id = "io_bazel_rules_scala_org_openjdk_jmh_jmh_generator_reflection",
        fetch_sources = False,
    )
    repository(
        id = "io_bazel_rules_scala_org_ows2_asm_asm",
        fetch_sources = False,
    )
    repository(
        id = "io_bazel_rules_scala_net_sf_jopt_simple_jopt_simple",
        fetch_sources = False,
    )
    repository(
        id = "io_bazel_rules_scala_org_apache_commons_commons_math3",
        fetch_sources = False,
    )

scala_deps = module_extension(implementation = _scala_deps_impl)
