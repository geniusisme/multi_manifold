def kt_native_binary(name, srcs, toolchain, **kwargs):
    native.genrule(
        name = name,
        srcs = srcs,
        cmd = "$(KOTLINC) $(SRCS) -o $@",
        executable = True,
        output_to_bindir = True,
        outs = [name + ".kexe"],
        toolchains = [toolchain],
        **kwargs
    )

def _kt_native_compiler_impl(ctx):
    return [
        platform_common.TemplateVariableInfo({
            "KOTLINC": ctx.attr.kotlinc_native_path
        })
    ]

kt_native_compiler = rule(
    implementation = _kt_native_compiler_impl,
    attrs = { "kotlinc_native_path": attr.string() }
)
