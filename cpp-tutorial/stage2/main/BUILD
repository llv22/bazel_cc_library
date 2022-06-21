load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

cc_library(
    name = "hello-tick",
    srcs = ["hello-tick.cc"],
    hdrs = ["hello-tick.h"],
)

cc_library(
    name = "hello-tick1",
    srcs = ["hello-tick1.cc"],
    hdrs = ["hello-tick1.h"],
    alwayslink = 1,
)

cc_library(
    name = "hello-greet",
    srcs = ["hello-greet.cc"],
    hdrs = ["hello-greet.h"],
    alwayslink = 1,
    deps = [":hello-tick", "hello-tick1"],
)

cc_binary(
    name = "hello-world",
    srcs = ["hello-world.cc"],
    deps = [
        ":hello-greet",
    ],
)