#!/bin/bash
# Usage: ./run.sh <architecture> <benchmark>
# Supported architectures are x86_64, aarch64, riscv32, riscv64

if [ "$#" -ne 2 ]; then
	echo "Usage: ./run.sh <architecture> <benchmark>"
	exit 1
fi

arch=$1
benchmark=$2
bench_name="$(basename $benchmark)"
./qemu/relbuild/qemu-${arch} -d plugin -plugin ./qpoints/libbbv.so,arg=${bench_name} ${benchmark}

./simpoints/bin/simpoint -inputVectorsGzipped -loadFVFile ${bench_name}_bbv.gz -k 10 -saveSimpoints ${bench_name}.simpts -saveSimpointWeights ${bench_name}.weights

./qemu/relbuild/qemu-${arch} -d plugin -plugin ./qpoints/libtracer.so,arg=${bench_name},arg=${arch} ${benchmark}

