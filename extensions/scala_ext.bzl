load("//third_party/repositories:repositories.bzl", "repository")
load("//scala:scala_maven_import_external.bzl", "java_import_external")
load("//private:format.bzl", "format_repositories")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazelci_rules//:rbe_repo.bzl", "rbe_preconfig")
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
    repository(id = "io_bazel_rules_scala_org_specs2_specs2_common")
    repository(id = "io_bazel_rules_scala_org_specs2_specs2_core")
    repository(id = "io_bazel_rules_scala_org_specs2_specs2_fp")
    repository(id = "io_bazel_rules_scala_org_specs2_specs2_matcher")
    repository(id = "io_bazel_rules_scala_junit_junit")
    repository(id = "io_bazel_rules_scala_org_hamcrest_hamcrest_core")
    repository(id = "io_bazel_rules_scala_org_specs2_specs2_junit")
    # bazel's java_import_external has been altered in rules_scala to be a macro based on jvm_import_external
    # in order to allow for other jvm-language imports (e.g. scala_import)
    # the 3rd-party dependency below is using the java_import_external macro
    # in order to make sure no regression with the original java_import_external
    java_import_external(
        name = "org_apache_commons_commons_lang_3_5_without_file",
        generated_linkable_rule_name = "linkable_org_apache_commons_commons_lang_3_5_without_file",
        jar_sha256 = "8ac96fc686512d777fca85e144f196cd7cfe0c0aec23127229497d1a38ff651c",
        jar_urls = ["https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.5/commons-lang3-3.5.jar"],
        licenses = ["notice"],  # Apache 2.0
        neverlink = True,
        testonly_ = True,
    )
    ## Linting
    format_repositories()
    http_archive(
        name = "remote_jdk8_macos",
        urls = [
            "https://mirror.bazel.build/openjdk/azul-zulu-8.50.0.51-ca-jdk8.0.275/zulu8.50.0.51-ca-jdk8.0.275-macosx_x64.tar.gz",
            "https://cdn.azul.com/zulu/bin/zulu8.50.0.51-ca-jdk8.0.275-macosx_x64.tar.gz"
        ],
        sha256 = "b03176597734299c9a15b7c2cc770783cf14d121196196c1248e80c026b59c17",
        strip_prefix = "zulu8.50.0.51-ca-jdk8.0.275-macosx_x64",
        build_file = "@rules_java//toolchains:jdk.BUILD",
    )
    http_archive(
        name = "remote_jdk8_windows",
        urls = [
            "https://mirror.bazel.build/openjdk/azul-zulu-8.50.0.51-ca-jdk8.0.275/zulu8.50.0.51-ca-jdk8.0.275-win_x64.zip",
            "https://cdn.azul.com/zulu/bin/zulu8.50.0.51-ca-jdk8.0.275-win_x64.zip",
        ],
        sha256 = "49759b2bd2ab28231a21ff3a3bb45824ddef55d89b5b1a05a62e26a365da0774",
        strip_prefix = "zulu8.50.0.51-ca-jdk8.0.275-win_x64",
        build_file = "@rules_java//toolchains:jdk.BUILD",
    )
    http_archive(
        name = "remote_jdk8_linux",
        urls = [
            "https://mirror.bazel.build/openjdk/azul-zulu-8.50.0.51-ca-jdk8.0.275/zulu8.50.0.51-ca-jdk8.0.275-linux_x64.tar.gz",
            "https://cdn.azul.com/zulu/bin/zulu8.50.0.51-ca-jdk8.0.275-linux_x64.tar.gz",
        ],
        sha256 = "1db6b2fa642950ee1b4b1ec2b6bc8a9113d7a4cd723f79398e1ada7dab1c981c",
        strip_prefix = "zulu8.50.0.51-ca-jdk8.0.275-linux_x64",
        build_file = "@rules_java//toolchains:jdk.BUILD",
    )
    repository(id = "org_scalameta_common")
    repository(id = "org_scalameta_fastparse")
    repository(id = "org_scalameta_fastparse_utils")
    repository(id = "org_scalameta_parsers")
    repository(id = "org_scalameta_scalafmt_core")
    repository(id = "org_scalameta_scalameta")
    repository(id = "org_scalameta_trees")
    repository(id = "org_typelevel_paiges_core")
    repository(id = "com_typesafe_config")
    repository(id = "org_scala_lang_scalap")
    repository(id = "com_thesamet_scalapb_lenses")
    repository(id = "com_thesamet_scalapb_scalapb_runtime")
    repository(id = "com_lihaoyi_fansi")
    repository(id = "com_lihaoyi_fastparse")
    repository(id = "org_scala_lang_modules_scala_collection_compat")
    repository(id = "com_lihaoyi_pprint")
    repository(id = "com_lihaoyi_sourcecode")
    repository(id = "com_google_protobuf_protobuf_java")
    repository(id = "com_geirsson_metaconfig_core")
    repository(id = "com_geirsson_metaconfig_typesafe_config")
    # test adding a scala jar:
    repository(id = "com_twitter__scalding_date", fetch_sources = False)
    # test of strict deps (scalac plugin UT + E2E)
    repository(id = "com_google_guava_guava_21_0_with_file", fetch_sources = False)
    repository(id = "com_github_jnr_jffi_native", fetch_sources = False)
    repository(id = "org_apache_commons_commons_lang_3_5", fetch_sources = False)
    repository(id = "com_google_guava_guava_21_0", fetch_sources = False)
    # test of import external
    # scala maven import external decodes maven artifacts to its parts
    # (group id, artifact id, packaging, version and classifier). To make sure
    # the decoding and then the download url composition are working the artifact example
    # must contain all the different parts and sha256s so the downloaded content will be
    # validated against it
    repository(id = "org_springframework_spring_core", fetch_sources = False)
    repository(id = "org_springframework_spring_tx", fetch_sources = False)
    repository(id = "org_typelevel_kind_projector", fetch_sources = False)
    # For testing that we don't include sources jars to the classpath
    repository(id = "org_typelevel__cats_core", fetch_sources = False)
    rbe_preconfig(
        name = "rbe_default",
        toolchain = "ubuntu2004-bazel-java11",
    )

scala_deps = module_extension(implementation = _scala_deps_impl)
