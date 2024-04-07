const std = @import("std");

// See https://github.com/andrewrk/ffmpeg/blob/main/build.zig

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "ctorch",
        .target = target,
        .optimize = optimize,
    });

    lib.addCSourceFiles(.{
        .files = &[_][]const u8{
            "src/torch_api.cpp",
        },
        .flags = &.{
            "-std=c++17",
            "-O3",
            "-g",
            "-Wall",
            "-Wno-unused-variable",
            "-Wno-deprecated-declarations",
            "-Wno-c++11-narrowing",
            "-Wno-sign-compare",
            "-Wno-unused-function",
            "-D_GLIBCXX_USE_CXX11_ABI=0",
        },
    });

    lib.addIncludePath(.{ .path = "include" });
    lib.addIncludePath(.{ .path = "/usr/local/lib/libtorch/include" });
    lib.addIncludePath(.{ .path = "/usr/local/lib/libtorch/include/torch/csrc/api/include" });
    lib.addIncludePath(.{ .path = "/usr/local/lib/libtorch/include/TH" });
    lib.addIncludePath(.{ .path = "/usr/local/lib/libtorch/include/THC" });
    lib.addIncludePath(.{ .path = "/usr/local/cuda/include" });

    lib.addLibraryPath(.{ .path = "/usr/local/lib/libtorch/lib" });
    lib.addLibraryPath(.{ .path = "/usr/local/cuda/lib64" });

    lib.linkLibC();
    lib.linkLibCpp();

    b.installArtifact(lib);

    // -L $(CUDA_HOME)/lib64
    // -L $(LIBTORCH_DIR)/lib \
    // -static-libstdc++ \
    // -ltorch \
    // -ltorch_cpu \
    // -ltorch_cuda \
    // -lc10
    // const torch_dep = b.dependency("torch", .{
    // .target = target,
    // .optimize = optimize,
    // });
    // const torch_cpu_dep = b.dependency("torch_cpu", .{
    // .target = target,
    // .optimize = optimize,
    // });
    // const torch_cuda_dep = b.dependency("torch_cuda", .{
    // .target = target,
    // .optimize = optimize,
    // });
    // const c10_dep = b.dependency("c10", .{
    // .target = target,
    // .optimize = optimize,
    // });
    // const static_libstdc_dep = b.dependency("static-libstdc++", .{
    // .target = target,
    // .optimize = optimize,
    // });
    // lib.linkLibrary(torch_dep.artifact("torch"));
    // lib.linkLibrary(torch_cpu_dep.artifact("torch_cpu"));
    // lib.linkLibrary(torch_cuda_dep.artifact("torch_cuda"));
    // lib.linkLibrary(c10_dep.artifact("c10"));
    // lib.linkLibrary(static_libstdc_dep.artifact("static-libstdc++"));
}
