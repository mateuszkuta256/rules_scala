load("@io_bazel_rules_scala//scala:scala.bzl", "scala_test")

def analyzer_tests_scala_3(suffix):
    common_jvm_flags = [
        "-Dplugin.jar.location=$(execpath //third_party/dependency_analyzer/src/main:dependency_analyzer%s)" % suffix,
        "-Dscala.library.location=$(rootpath @io_bazel_rules_scala_scala_library%s)" % suffix,
        # Scala 2 standard library is required for compilation.
        # Without it compilation fails with error:
        # class dotty.tools.dotc.core.Symbols$NoSymbol$ cannot be cast to class dotty.tools.dotc.core.Symbols$ClassSymbol
        "-Dscala.library2.location=$(rootpath @io_bazel_rules_scala_scala_library_2%s)" % suffix,
    ]

    scala_test(
        name = "test_that_tests_run",
        size = "small",
        jvm_flags = common_jvm_flags,
        srcs = [
            "io/bazel/rulesscala/dependencyanalyzer3/CompileTest.scala",
        ],
        deps = [
            "//scala/private/toolchain_deps:scala_compile_classpath",
            "//third_party/dependency_analyzer/src/main:dependency_analyzer" + suffix,
            "//third_party/utils/src/test:test_util",
            "@io_bazel_rules_scala_scala_library" + suffix,
            "@io_bazel_rules_scala_scala_library_2" + suffix,
        ],
    )
