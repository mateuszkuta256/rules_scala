def _test_new_local_repo_impl(repository_ctx):
    build = []
    build.append("filegroup(")
    build.append("    name = \"data\",")
    build.append("    srcs = glob([\"**/*.txt\"]),")
    build.append("    visibility = [\"//visibility:public\"],")
    build.append(")")
    repository_ctx.file("BUILD", "\n".join(build))
    repository_ctx.file("resource.txt", "A resource")

_test_new_local_repo = repository_rule(
    implementation = _test_new_local_repo_impl,
)

def test_new_local_repo():
    _test_new_local_repo(name = "test_new_local_repo")
