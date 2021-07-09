git submodule update --init --recursive

pushd qemu
mkdir relbuild
pushd relbuild
../configure --target-list=aarch64-softmmu,x86_64-softmmu,riscv64-softmmu,aarch64-linux-user,x86_64-linux-user,riscv64-linux-user
make -j4
popd
popd

pushd qpoints
QEMU_DIR=../qemu make
popd

pushd simpoints
make
popd

