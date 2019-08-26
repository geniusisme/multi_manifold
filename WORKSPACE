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

#http_archive(
 #   name = "bazel_skylib",
 #   sha256 = "eb5c57e4c12e68c0c20bc774bfbc60a568e800d025557bc4ea022c6479acc867",
  #  strip_prefix = "bazel-skylib-0.6.0",
   # url = "https://github.com/bazelbuild/bazel-skylib/archive/0.6.0.tar.gz",
#)

load("@io_bazel_rules_rust//rust:repositories.bzl", "rust_repositories")
rust_repositories()

load("@io_bazel_rules_rust//:workspace.bzl", "bazel_version")
bazel_version(name = "bazel_version")
