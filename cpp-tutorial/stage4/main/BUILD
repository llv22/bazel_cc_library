load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")
load("//main:tensorflow.bzl", "incremental_cc_combine")

# cc_library(
#     name = "libincremental_pywrap_tf.1",
#     srcs = [":libincremental_pywrap_tf.1.so"],
# )

# incremental_cc_combine(
#     name = "incremental_pywrap_tf.1",
#     genstatic = False,
#     output = "libincremental_pywrap_tf.1.so",
#     deps = [":hello-greet"]
# )

# cc_library(
#     name = "hello-greet",
#     # linkshared = 1,
#     # srcs = ["hello-greet.cc", "hello-greet.h"],
#     srcs = ["hello-greet.cc"],
#     hdrs = ["hello-greet.h"],
# )

cc_library(
  name="hello-greet.so",
  srcs = ["hello-greet.cc"],
  hdrs = ["hello-greet.h"],
  visibility=["//visibility:public"],
#   linkopts = ["-shared"],
)

cc_library(
  name="hello-tick.so",
  srcs = ["hello-tick.cc"],
  hdrs = ["hello-tick.h"],
  visibility=["//visibility:public"],
#   linkopts = ["-shared"],
)

cc_binary(
    name = "hello-world",
    srcs = ["hello-world.cc"],
    deps = [
        ":hello-greet.so",
        ":hello-tick.so",
    ],
    # linkstatic=False,
    linkshared = 1,
    # linkshared = True,
)

# cc_binary(
#   name="hello-greet.so",
#   srcs = ["hello-greet.cc", "hello-greet.h"],
#   visibility=["//visibility:public"],
#   linkopts = ["-shared"],
# )

# cc_library(
#     name = "libincremental_pywrap_tf.1",
#     srcs = [":hello-greet.so"],
# )

# cc_binary(
#     name = "hello-world",
#     srcs = ["hello-world.cc"],
#     deps = [
#         ":libincremental_pywrap_tf.1",
#     ],
#     linkstatic=False,
# )