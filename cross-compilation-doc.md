# Cross compilation support

## Toolchain configuration
Cross compilation support will require registration of multiple scala toolchains. This can be done manually,
see [scala_toolchain.md](docs/scala_toolchain.md)

1. Add your own definition of `scala_toolchain` to a `BUILD` file:
    ```starlark
    # //toolchains/BUILD
    load("//scala:scala.bzl", "setup_scala_toolchain")

    setup_scala_toolchain(
        name = "my_toolchain",
        # configure toolchain dependecies
        parser_combinators_deps = [
            "@maven//:org_scala_lang_modules_scala_parser_combinators_2_12",
        ],
        scala_compile_classpath = [
            "@maven//:org_scala_lang_scala_compiler",
            "@maven//:org_scala_lang_scala_library",
            "@maven//:org_scala_lang_scala_reflect",
        ],
        scala_library_classpath = [
            "@maven//:org_scala_lang_scala_library",
            "@maven//:org_scala_lang_scala_reflect",
        ],
        scala_macro_classpath = [
            "@maven//:org_scala_lang_scala_library",
            "@maven//:org_scala_lang_scala_reflect",
        ],
        scala_xml_deps = [
            "@maven//:org_scala_lang_modules_scala_xml_2_12",
        ],
        # example of setting attribute values
        scalacopts = ["-Ywarn-unused"],
        unused_dependency_checker_mode = "off",
        visibility = ["//visibility:public"]
    )
    ```

2. Register your custom toolchain from `WORKSPACE`:
    ```python
    # WORKSPACE
    register_toolchains("//toolchains:my_scala_toolchain")
    ```
   
We want to perform such registrations automatically, thus gonna need some sort of configuration. This will be held in a [config](scala_config.bzl) repository

The new meaning of `scala_version`, `scala_versions` parameters is:

- `scala_version`- the default version, we will fall back to this value whenever scala version is required and not specified explicitly
- `scala_versions` - a list of all the versions supported by the repository

Once `scala_versions` is set, we can continue with [toolchain registration](private/macros/setup_scala_toolchain.bzl)

```starlark
for scala_version in SCALA_VERSIONS:
    setup_scala_toolchain(
        name = sanitize_version(scala_version) + "_toolchain",
        scala_version = scala_version,
        parser_combinators_deps = _parser_combinators_deps(scala_version),
        scala_compile_classpath = _scala_compile_classpath_deps(scala_version),
        scala_library_classpath = _scala_library_classpath_deps(scala_version),
        scala_macro_classpath = _scala_macro_classpath_deps(scala_version),
        scala_xml_deps = _scala_xml_deps(scala_version),
        semanticdb_deps = _scala_semanticdb_deps(scala_version),
        use_argument_file_in_runner = True,
    )
```

Please note there are special functions defined for supplying the dependencies. These are needed to add 'version suffix', required to avoid names collision. For example, if repository supports both `2.13.12` and `3.3.1`, we will have to register two compilers, instead of single `io_bazel_rules_scala_scala_compiler` like so far: 
- `io_bazel_rules_scala_scala_compiler_2_13_12`
- `io_bazel_rules_scala_scala_compiler_3_3_1`

These repositories are defined in another [scala_repositories.bzl](scala/private/macros/scala_repositories.bzl) file:

```starlark
for scala_version in SCALA_VERSIONS:
    toolchain_repositories(
        scala_version,
        for_artifact_ids = _artifact_ids(scala_version),
        maven_servers = maven_servers,
        fetch_sources = fetch_sources,
        overriden_artifacts = overriden_artifacts,
        validate_scala_version = validate_scala_version,
    )
```

`toolchain_repositories` is the new function that appends scala version to the name of each artifact. It is crucial for the remaining toolchains too (scalatest, scalafmt)

Along with definition, there's also automatic registration of the toolchains:
```starlark
def scala_register_toolchains():
    for scala_version in SCALA_VERSIONS:
        native.register_toolchains(
            "@io_bazel_rules_scala//scala:%s_toolchain" % sanitize_version(scala_version),
        )
```

### Challenges
Currently automatic toolchain registration does not consume any parameters that would allow to override default settings. I can think of a map parameter (version -> settings) or some global config like suggested [here](https://github.com/bazelbuild/rules_scala/pull/1546#pullrequestreview-1916153978)

## Scalafmt toolchain

Same as for 'scala toolchain' we have to define [repositories](scalafmt/scalafmt_repositories.bzl), then [setup and register](scalafmt/toolchain/setup_scalafmt_toolchain.bzl) toolchains for each supported version.
There's a [test_cross_build](test_cross_build/src/main/scalafmt/BUILD) workspace that tests and demonstrates formatting of cross-versioned sources


## Scalatest toolchain

The process is same as for above toolchains, see [testing.bzl](testing/testing.bzl)

## 'scala-version' config setting

Besides `scala_versions` parameter, [scala_config](scala_config.bzl) repository has been extended with a set of config settings:

```starlark
string_flag(
    name = "scala_version",
    build_setting_default = "",
    values = [
        "",
        "2.11.12",
        "2.12.18",
        "2.13.12",
        "3.1.0",
        "3.2.1",
        "3.3.1",
    ],
    visibility = ["//visibility:public"],
)

config_setting(
    name = "2_11_12",
    flag_values = {":scala_version": "2.11.12"},
)

config_setting(
    name = "2_12_18",
    flag_values = {":scala_version": "2.12.18"},
)
...
```

Above code is generated automatically, so it contains only the required 'flags' for the versions that are necessary. These are used to pick a proper toolchain for a given rule

## Toolchain selection

### 'scala-version' transition

Proper toolchain selection is based on [transition](https://bazel.build/rules/lib/builtins/transition#transition) defined [here](scala_cross_version.bzl):
```starlark
def _scala_version_transition_impl(settings, attr):
    if attr.scala_version:
        return {"@io_bazel_rules_scala_config//:scala_version": attr.scala_version}
    else:
        return {}

scala_version_transition = transition(
    implementation = _scala_version_transition_impl,
    inputs = [],
    outputs = ["@io_bazel_rules_scala_config//:scala_version"],
)

toolchain_transition_attr = {
    "scala_version": attr.string(),
    "_allowlist_function_transition": attr.label(
        default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
    ),
}
```

Every rule that needs a various toolchain depending on 'scala-version' must be linked to a transition, e.g.:
```starlark
def make_scala_library(*extras):
    return rule(
        attrs = _dicts.add(
            _scala_library_attrs,
            extras_phases(extras),
            *[extra["attrs"] for extra in extras if "attrs" in extra]
        ),
        fragments = ["java"],
        outputs = _dicts.add(
            common_outputs,
            *[extra["outputs"] for extra in extras if "outputs" in extra]
        ),
        toolchains = [
            "@io_bazel_rules_scala//scala:toolchain_type",
            "@bazel_tools//tools/jdk:toolchain_type",
        ] + (["@io_bazel_rules_scala//scala/scalafmt/toolchain:scalafmt_toolchain_type"] if hasattr(extras, "format") else []),
        cfg = scala_version_transition,
        incompatible_use_toolchain_transition = True,
        implementation = _scala_library_impl,
    )
```

These are the rules that use transitions and support cross-compilation:

- [scala_library](scala/private/rules/scala_library.bzl)
- [scala_binary](scala/private/rules/scala_binary.bzl)
- [scala_repl](scala/private/rules/scala_repl.bzl)
- [scala_test](scala/private/rules/scala_test.bzl)
- whatever rule with 'scalafmt' [extension](scala/scalafmt/phase_scalafmt_ext.bzl)

Please note that transitions bring additional impact on memory and performance. Detailed doc [here](https://bazel.build/extending/config#memory-performance-considerations)

## Target settings

Every toolchain discussed so far has an additional parameter:
`target_settings = ["@io_bazel_rules_scala_config//:" + sanitize_version(scala_version)] if scala_version != SCALA_VERSION else []`

It's a constraint that tells which toolchain should be picked for a given transition/config. Please note that for default SCALA_VERSION we don't specify the parameter. This effectively makes the toolchain default - it will always be matched if none other found.

## Scalac

So far, there was only one 'scalac' worker, build based on `SCALA_VERSION`, and triggered on compilation phase. Since we want to build both scala 2/3 in a single repository, we have to define multiple versions of this target. Check [scalac.bzl](src/java/io/bazel/rulesscala/scalac/scalac.bzl) for details.

We can select proper worker during [compilation](scala/private/phases/phase_compile.bzl) like this:
```starlark
def _select_scalac(ctx):
    scala_version = ctx.toolchains["@io_bazel_rules_scala//scala:toolchain_type"].scala_version
    version_suffix = sanitize_version(scala_version)
    for scalac in ctx.attr._scalac:
        if scalac.label.name.endswith(version_suffix):
            return scalac.files_to_run
    return ctx.attr._scalac[0].files_to_run
```
Problem with multiple `scalac` targets can be solved in many different ways. See [PR](https://github.com/bazelbuild/rules_scala/pull/1546#issuecomment-1953860108) discussion and proposed solutions

## BSP support

All the changes presented so far are backward-compatible, except BSP support. Since [_scalac](https://github.com/JetBrains/bazel-bsp/blob/master/aspects/core.bzl#L42)  'common' parameter became a list, there will be changes required in the [aspect](https://github.com/JetBrains/bazel-bsp/blob/master/aspects/rules/scala/scala_info.bzl#L3)

This is one of the remaining TODOs

## TODO

- BSP support
- separate configuration - currently toolchains often share single config (like `ENABLE_COMPILER_DEPENDENCY_TRACKING`) - can consider [this](https://github.com/bazelbuild/rules_scala/pull/1546#pullrequestreview-1916153978)
- maybe add some more tests 