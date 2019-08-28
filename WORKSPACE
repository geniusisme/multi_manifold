load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "rules_haskell",
    type = "tar.gz",
    strip_prefix = "tweag-rules_haskell-0806248",
    urls = ["https://github.com/tweag/rules_haskell/tarball/master"],
)

load(
    "@rules_haskell//haskell:repositories.bzl",
    "rules_haskell_dependencies",
    "rules_haskell_toolchains",
)

rules_haskell_dependencies()
rules_haskell_toolchains(version = "8.6.5")

http_archive(
    name = "io_bazel_rules_rust",
    type="tar.gz",
    strip_prefix = "bazelbuild-rules_rust-05bd7d1",
    urls = ["https://github.com/bazelbuild/rules_rust/tarball/master"],
)

load("@io_bazel_rules_rust//rust:repositories.bzl", "rust_repositories")
rust_repositories()

load("@io_bazel_rules_rust//:workspace.bzl", "bazel_version")
bazel_version(name = "bazel_version")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

rules_kotlin_version = "9051eb053f9c958440603d557316a6e9fda14687"
#"67f4a6050584730ebae7f8a40435a209f8e0b48e"

http_archive(
    name = "io_bazel_rules_kotlin",
    urls = ["https://github.com/bazelbuild/rules_kotlin/archive/%s.zip" % rules_kotlin_version],
    type = "zip",
    strip_prefix = "rules_kotlin-%s" % rules_kotlin_version
)

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kotlin_repositories", "kt_register_toolchains")
kotlin_repositories()
kt_register_toolchains()
