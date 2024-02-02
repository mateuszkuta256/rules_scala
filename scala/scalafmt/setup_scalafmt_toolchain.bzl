load("//scala/scalafmt/toolchain:toolchain.bzl", "scalafmt_toolchain")
load("//scala:providers.bzl", "declare_deps_provider")

def setup_scalafmt_toolchain(
        name,
        scalafmt_classpath,
        scala_version = None,
        visibility = ["//visibility:public"]):
    scalafmt_classpath_provider = "%scalafmt_classpath_provider" % name
    declare_deps_provider(
        name = scalafmt_classpath_provider,
        deps_id = "scalafmt_classpath",
        visibility = visibility,
        deps = scalafmt_classpath,
    )
    scalafmt_toolchain(
        name = "%s_impl" % name,
        dep_providers = [scalafmt_classpath_provider],
        visibility = visibility,
        scala_version = scala_version
    )
    native.toolchain(
        name = name,
        toolchain = ":%s_impl" % name,
        target_settings = ["//scala/versions:" + scala_version] if scala_version else [],
        toolchain_type = "//scala/scalafmt/toolchain:scalafmt_toolchain_type",
        visibility = visibility,
    )
