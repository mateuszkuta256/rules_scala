exports_files([
    "byes",
    "hellos",
    "more-byes",
    "more-hellos",
])

genrule(
    name = "generated-hello",
    outs = ["generated-hello.txt"],
    cmd = "echo 'hello' > $@",
    visibility = ["//visibility:public"],
)
