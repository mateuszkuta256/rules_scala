def scala_register_toolchains():
    native.register_toolchains(
        "@io_bazel_rules_scala//scala:3_3_0_toolchain",
    )
    native.register_toolchains(
        "@io_bazel_rules_scala//scala:2_13_12_toolchain",
    )
    native.register_toolchains(
        "@io_bazel_rules_scala//scala:default_toolchain",
    )

def scala_register_unused_deps_toolchains():
    native.register_toolchains(
        "@io_bazel_rules_scala//scala:unused_dependency_checker_error_toolchain",
    )
