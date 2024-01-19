def _proto_cross_repo_boundary_repository_impl(repository_ctx):
    build = []
    build.append("load(\"@rules_proto//proto:defs.bzl\", \"proto_library\")")
    build.append("proto_library(")
    build.append("    name = \"sample_proto\",")
    build.append("    srcs = [\"sample.proto\"],")
    build.append("    visibility = [\"//visibility:public\"],")
    build.append(")")

    proto = []
    proto.append("syntax = \"proto3\";")
    proto.append("package sample;")
    proto.append("option java_package = \"sample\";")
    proto.append("message Sample {")
    proto.append("  repeated string foobar = 1;")
    proto.append("}")

    repository_ctx.file("sample.proto", "\n".join(proto))
    repository_ctx.file("BUILD", "\n".join(build))

_proto_cross_repo_boundary_repository = repository_rule(
    implementation = _proto_cross_repo_boundary_repository_impl,
)

def proto_cross_repo_boundary_repository():
    _proto_cross_repo_boundary_repository(name = "proto_cross_repo_boundary")
