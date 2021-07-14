git submodule update --init --recursive

pushd qemu
mkdir relbuild
pushd relbuild
../configure --target-list=aarch64-softmmu,x86_64-softmmu,riscv64-softmmu,aarch64-linux-user,x86_64-linux-user,riscv64-linux-user --enable-plugins
make -j4
popd
popd

pushd qpoints
QEMU_DIR=../qemu make
popd

pushd simpoints
make
popd

pushd riscv/u-boot
CROSS_COMPILE=riscv64-linux-gnu- make qemu-riscv64_smode_defconfig
CROSS_COMPILE=riscv64-linux-gnu- make -j4
popd

pushd riscv/opensbi
CROSS_COMPILE=riscv64-linux-gnu- make PLATFORM=generic FW_PAYLOAD_PATH=../u-boot/u-boot.bin
popd

mkdir riscv/image
pushd riscv/image
wget https://gitlab.com/api/v4/projects/giomasce%2Fdqib/jobs/artifacts/master/download?job=convert_riscv64-virt -O artifacts.zip
unzip artifacts.zip
popd

