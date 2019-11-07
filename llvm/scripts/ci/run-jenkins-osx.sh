#!/bin/bash -e

echo "ENVIRONMENT:"
env

llvm_CMAKE_FLAGS="-DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD=X86;ARM;AArch64 -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly -DLLVM_BUILD_TESTS=Off -DLLVM_INCLUDE_TESTS=Off -DLLVM_TOOLS_TO_BUILD=opt;llc;llvm-config;llvm-dis -G Ninja"

rm -rf build
mkdir -p build
cd build
cmake $llvm_CMAKE_FLAGS -DCMAKE_INSTALL_PREFIX=$PWD/../usr64 ../llvm/
ninja
ninja install
cd ..

rm -rf tmp-bin
mkdir tmp-bin
cp usr64/bin/{llc,opt,llvm-dis,llvm-config} tmp-bin/
rm usr64/bin/*
cp tmp-bin/* usr64/bin/

rm -f usr64/lib/libLTO.* usr64/lib/*.dylib
tar cvzf llvm-osx64-$GIT_COMMIT.tar.gz usr64
