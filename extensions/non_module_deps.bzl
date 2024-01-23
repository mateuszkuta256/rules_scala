load("//third_party/repositories:repositories.bzl", "repository")
load(
    "@io_bazel_rules_scala//scala/private:macros/scala_repositories.bzl",
    _dt_patched_compiler_setup = "dt_patched_compiler_setup",
)

def _non_module_deps_impl(ctx):
    _dt_patched_compiler_setup()
    repository(
        id = "io_bazel_rules_scala_scala_library",
        validate_scala_version = True,
    )
    repository(
        id = "io_bazel_rules_scala_scala_compiler",
        validate_scala_version = True,
    )
    repository(
        id = "io_bazel_rules_scala_scala_xml",
        validate_scala_version = True,
    )
    repository(
        id = "io_bazel_rules_scala_scala_parser_combinators",
        validate_scala_version = True,
    )
    repository(
        id = "io_bazel_rules_scala_scala_interfaces",
        validate_scala_version = True,
    )
    repository(
        id = "io_bazel_rules_scala_scala_reflect",
        validate_scala_version = True,
    )
    repository(
        id = "org_scalameta_semanticdb_scalac",
        validate_scala_version = True,
    )
    repository(
        id = "io_bazel_rules_scala_scala_tasty_core",
        validate_scala_version = True,
    )
    repository(
        id = "io_bazel_rules_scala_scala_asm",
        validate_scala_version = True,
    )
    repository(
        id = "io_bazel_rules_scala_scala_library_2",
        validate_scala_version = True,
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
    repository(
        id = "scala_proto_rules_scalapb_plugin",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_protoc_bridge",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_scalapb_runtime",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_scalapb_runtime_grpc",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_scalapb_lenses",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_scalapb_fastparse",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_grpc_core",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_grpc_api",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_grpc_stub",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_grpc_protobuf",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_grpc_netty",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_grpc_context",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_perfmark_api",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_guava",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_google_instrumentation",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_netty_codec",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_netty_codec_http",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_netty_codec_socks",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_netty_codec_http2",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_netty_handler",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_netty_buffer",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_netty_transport",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_netty_resolver",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_netty_common",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_netty_handler_proxy",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_opencensus_api",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_opencensus_impl",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_disruptor",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_opencensus_impl_core",
        fetch_sources = False,
    )
    repository(
        id = "scala_proto_rules_opencensus_contrib_grpc_metrics",
        fetch_sources = False,
    )
    repository(id = "io_bazel_rules_scala_scalatest")
    repository(id = "io_bazel_rules_scala_scalatest_compatible")
    repository(id = "io_bazel_rules_scala_scalatest_core")
    repository(id = "io_bazel_rules_scala_scalatest_featurespec")
    repository(id = "io_bazel_rules_scala_scalatest_flatspec")
    repository(id = "io_bazel_rules_scala_scalatest_freespec")
    repository(id = "io_bazel_rules_scala_scalatest_funsuite")
    repository(id = "io_bazel_rules_scala_scalatest_funspec")
    repository(id = "io_bazel_rules_scala_scalatest_matchers_core")
    repository(id = "io_bazel_rules_scala_scalatest_shouldmatchers")
    repository(id = "io_bazel_rules_scala_scalatest_mustmatchers")
    repository(id = "io_bazel_rules_scala_scalactic")

non_module_deps = module_extension(implementation = _non_module_deps_impl)
