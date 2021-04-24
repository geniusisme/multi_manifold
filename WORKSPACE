load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")


#haskell

# Download rules_haskell and make it accessible as "@rules_haskell".
http_archive(
    name = "rules_haskell",
    strip_prefix = "rules_haskell-0.13",
    urls = ["https://github.com/tweag/rules_haskell/archive/v0.13.tar.gz"],
    sha256 = "b4e2c00da9bc6668fa0404275fecfdb31beb700abdba0e029e74cacc388d94d6",
)

load(
    "@rules_haskell//haskell:repositories.bzl",
    "rules_haskell_dependencies",
)

# Setup all Bazel dependencies required by rules_haskell.
rules_haskell_dependencies()

load(
    "@rules_haskell//haskell:toolchain.bzl",
    "rules_haskell_toolchains",
)

load(
    "@rules_haskell//haskell:cabal.bzl",
    "stack_snapshot"
)

stack_snapshot(
    name = "stackage",
    extra_deps = {"zlib": ["@zlib.dev//:zlib"]},
    packages = ["zlib"],
    # Last snapshot published for ghc-8.6.5 the default version picked up by
    # rules_haskell
    snapshot = "lts-14.27",
    # This uses an unpinned version of stack_snapshot, meaning that stack is invoked on every build.
    # To switch to pinned stackage dependencies, run `bazel run @stackage-unpinned//:pin` and
    # uncomment the following line.
    # stack_snapshot_json = "//:stackage_snapshot.json",
)

# Download a GHC binary distribution from haskell.org and register it as a toolchain.
rules_haskell_toolchains()

http_archive(
    name = "zlib.dev",
    build_file = "//:zlib.BUILD.bazel",
    sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",
    strip_prefix = "zlib-1.2.11",
    urls = [
        "https://mirror.bazel.build/zlib.net/zlib-1.2.11.tar.gz",
        "http://zlib.net/zlib-1.2.11.tar.gz",
    ],
)


#rust



http_archive(
    name = "rules_rust",
    sha256 = "e6d835ee673f388aa5b62dc23d82db8fc76497e93fa47d8a4afe97abaf09b10d",
    strip_prefix = "rules_rust-f37b9d6a552e9412285e627f30cb124e709f4f7a",
    urls = [
        # Master branch as of 2021-01-27
        "https://github.com/bazelbuild/rules_rust/archive/f37b9d6a552e9412285e627f30cb124e709f4f7a.tar.gz",
    ],
)

load("@rules_rust//rust:repositories.bzl", "rust_repositories")

rust_repositories()

rules_kotlin_version = "legacy-1.3.0"
rules_kotlin_sha = "4fd769fb0db5d3c6240df8a9500515775101964eebdf85a3f9f0511130885fde"
http_archive(
    name = "io_bazel_rules_kotlin",
    urls = ["https://github.com/bazelbuild/rules_kotlin/archive/%s.zip" % rules_kotlin_version],
    type = "zip",
    strip_prefix = "rules_kotlin-%s" % rules_kotlin_version,
    sha256 = rules_kotlin_sha,
)

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kotlin_repositories", "kt_register_toolchains")
kotlin_repositories() # if you want the default. Otherwise see custom kotlinc distribution below
kt_register_toolchains() # to use the default toolchain, otherwise see toolchains below
