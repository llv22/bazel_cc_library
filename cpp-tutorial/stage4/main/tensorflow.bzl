load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")   
# load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "C_COMPILE_ACTION_NAME")

def _combine_impl(ctx):
    cc_toolchain = find_cpp_toolchain(ctx)    

    target_list = []
    for dep_target in ctx.attr.deps:        
        # CcInfo, InstrumentedFilesInfo, OutputGroupInfo      
        cc_info_linker_inputs = dep_target[CcInfo].linking_context.linker_inputs
        for linker_in in cc_info_linker_inputs.to_list():            
            for linker_in_lib in linker_in.libraries:          
                if linker_in_lib.static_library != None:
                    target_list.append(linker_in_lib.static_library)
    
    output = ctx.outputs.output
    if ctx.attr.genstatic:
        # still have bug for ar, as static libraries may have the same name under the same folder, refer to https://cloud.tencent.com/developer/article/1669789, https://blog.fearcat.in/a?ID=01800-1382ef06-27b7-4b13-aa66-b297d5767c01 and https://docs.bazel.build/versions/main/integrating-with-rules-cc.html
        cp_command = ""       
        processed_list = []
        processed_path_list = []
        for dep in target_list:
            cp_command += "cp -a "+ dep.path +" "+ output.dirname + "/&&"
            processed = ctx.actions.declare_file(dep.basename)
            processed_list += [processed]
            processed_path_list += [dep.path]
        cp_command += "echo'starting to run shell'"
        processed_path_list += [output.path]
  
        print("cp_command = ", cp_command)
        ctx.actions.run_shell(
            outputs = processed_list,
            inputs = target_list,
            command = cp_command,
        )

        command = "cd {} && ar -x {} {}".format(
                output.dirname,
                "&& ar -x ".join([dep.basename for dep in target_list]),
                "&& ar -rc libauto.a *.o"
            )
        print("ar command = ", command)
        ctx.actions.run_shell(
            outputs = [output],
            inputs = processed_list,
            command = command,
        )
    else:
        counter = {}
        for dep in target_list:
            if dep in counter:
                counter[dep.path] += 1
            else:
                counter[dep.path] = 1

        paths = list(counter.keys())
        size = 200
        max_argument_size = 262144
        segment_len = len(paths)//size + (int)(len(paths)%size != 0)
        print("segment_len = {}, total size = {}".format(segment_len, len(paths)))
        inter_libraries = []
        for x in range(segment_len):
            if (x+1)*size > len(paths):
                end = len(paths)
            else:
                end = (x+1)*size
            command = "export PATH=$PATH:{} && {} -shared -fPIC {} -o {} -pthread -lm -ldl -lpthread -Wl,-framework -Wl,SystemConfiguration -Wl,-S -lc++ -no-canonical-prefixes -undefined dynamic_lookup".format (
                cc_toolchain.ld_executable,
                cc_toolchain.compiler_executable,
                " -Wl,-force_load,".join(paths[x*size:end]),
                "inter_{}_{}.so".format(output.basename, x)
            )
            inter_libraries.append("inter_{}_{}.so".format(output.basename, x))
            if len(command) - max_argument_size > 0:
                fail("dynamic command argument validation failed, as oversizing by {} with dependencies size = {}.".format(len(command) - max_argument_size, len(paths)))
            print("dynamic command = {}, paths = {}, outputs = {},  inputs = {}".format(command, paths[x*size:end], [ctx.actions.declare_file("inter_{}_{}.so".format(output.basename, x))], [ctx.actions.declare_file(f) for f in paths[x*size:end]]))
            ctx.actions.run_shell(
                outputs = [ctx.actions.declare_file("inter_{}_{}.so".format(output.basename, x))],
                inputs = [ctx.actions.declare_file(f) for f in paths[x*size:end]],
                command = command,
            )
        
        command = "export PATH=$PATH:{} && {} -shared -fPIC {} -o {} -pthread -lm -ldl -lpthread -Wl,-framework -Wl,SystemConfiguration -Wl,-S -lc++ -no-canonical-prefixes -undefined dynamic_lookup".format (
            cc_toolchain.ld_executable,
            cc_toolchain.compiler_executable,
            " -Wl,-force_load,".join(inter_libraries),
            output.basename
        )
        print("merging command = {}, outputs = {}, inputs = {}".format(command, [output], [ctx.actions.declare_file(f) for f in inter_libraries]))
        ctx.actions.run_shell(
            outputs = [output],
            inputs = [ctx.actions.declare_file(f) for f in inter_libraries],
            command = command,
        )

    return [DefaultInfo(files = depset([output]))]

incremental_cc_combine = rule(
    implementation = _combine_impl,
    attrs = {
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
        "genstatic": attr.bool(default = False),
        "deps": attr.label_list(),
        "output": attr.output()
    },
)