# ctorch

`ctorch` is a C binding to Pytorch C++. It can be used as base to build Pytorch binding in other languages. Here, it is for building `ztorch` a Pytorch binding for zig language.

## Build library with `make`

`libctorch.so` will be built and saved at `lib` directory.

```bash
# clean up previous built library
make clean
make all
```

## Build library with `cmake`

- `libctorch.so` will be built and saved at `cmake-output/lib`
- header files will be copied to `cmake-output/include`

```bash
cmake -B build -S .

cd build && make install

```

## Build libary with `zig build`

```bash
zig build
```

Add it to your `build.zig.zon`. 

```yaml
    .ctorch = .{
        .url = "https://github.com/sugarme/ctorch/archive/a5a388a32d230a89a4a64d071657b6dd5e4e3bec.tar.gz",
        .hash = "122084941d6e06491a85e1356c7cca24a078103d34155e34a10a16a53f420d6bc399",
    },
```


Then it can be used in the consumer project `build.zig` file as

```zig
    const ctorch_dep = b.dependency("ctorch", .{
        .target = target,
        .optimize = optimize,
    });

    lib.linkLibrary(ctorch_dep.artifact("ctorch"));
```
