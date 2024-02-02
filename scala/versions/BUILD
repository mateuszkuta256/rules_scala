load("@bazel_skylib//rules:common_settings.bzl", "string_flag")

string_flag(
    name = "scala_version",
    build_setting_default = "",
    values = [
        "",
        "2_13_12",
        "3_3_0",
    ],
    visibility = ["//visibility:public"],
)

config_setting(
    name = "2_13_12",
    flag_values = {":scala_version": "2_13_12"},
)

config_setting(
    name = "3_3_0",
    flag_values = {":scala_version": "3_3_0"},
)
