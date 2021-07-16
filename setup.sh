#!/bin/bash

git submodule update --init --recursive

mkdir -p qemu/relbuild
pushd qemu/relbuild/
../configure --target-list=aarch64-softmmu,x86_64-softmmu,riscv64-softmmu,aarch64-linux-user,x86_64-linux-user,riscv64-linux-user,riscv32-linux-user --enable-plugins --enable-capstone=git
make -j4
popd

pushd qpoints
QEMU_DIR=../qemu make
popd

pushd simpoints
make
popd

#pushd riscv/u-boot
#CROSS_COMPILE=riscv64-linux-gnu- make qemu-riscv64_smode_defconfig
#CROSS_COMPILE=riscv64-linux-gnu- make -j4
#popd

#pushd riscv/opensbi
#CROSS_COMPILE=riscv64-linux-gnu- make PLATFORM=generic FW_PAYLOAD_PATH=../u-boot/u-boot.bin
#popd

#mkdir riscv/image
#pushd riscv/image
#wget https://gitlab.com/api/v4/projects/giomasce%2Fdqib/jobs/artifacts/master/download?job=convert_riscv64-virt -O artifacts.zip
#unzip artifacts.zip
#popd

#pushd tests
#riscv64-linux-gnu-gcc -static -o tests/test tests/test.c
#popd
#./run_usermode.sh riscv64 tests/test
