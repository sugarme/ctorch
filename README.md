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
