load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")
load("//main:tensorflow.bzl", "incremental_cc_combine")

incremental_cc_combine(
    name = "incremental_pywrap_tf.1",
    genstatic = False,
    output = "libincremental_pywrap_tf.1.so",
    deps = [":hello-greet"]
)

cc_library(
    name = "libincremental_pywrap_tf.1",
    srcs = [":libincremental_pywrap_tf.1.so"],
)

cc_library(
    name = "hello-greet",
    srcs = ["hello-greet.cc"],
    hdrs = ["hello-greet.h"],
)

cc_binary(
    name = "hello-world",
    srcs = ["hello-world.cc"],
    deps = [
        ":libincremental_pywrap_tf.1",
    ],
)