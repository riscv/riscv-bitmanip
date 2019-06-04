#!/bin/bash
set -ex
if ! test -f gcc-9.1.0.tar.xz; then
  wget ftp://ftp.lip6.fr/pub/gcc/releases/gcc-9.1.0/gcc-9.1.0.tar.xz
fi
if ! test -d gcc-9.1.0; then
	tar xJf gcc-9.1.0.tar.xz
	cd gcc-9.1.0
	git init; git add .; git commit -m upstream
	patch -p1 < ../gcc.diff
	cd ..
fi
mkdir gcc-build
cd gcc-build
../gcc-9.1.0/configure --prefix=/opt/riscv64b --target=riscv64-unkown-elf --enable-languages=c --disable-libssp
make -j$(nproc)
make install
ln -fs riscv64-unkown-elf-gcc /opt/riscv64b/bin/riscv64-unkown-elf-cc
cp ../../cproofs/rvintrin.h /opt/riscv64b/lib/gcc/riscv64-unkown-elf/9.1.0/include/
