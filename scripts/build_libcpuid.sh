#!/bin/bash

set -euo pipefail
source /etc/os-release

if [[ $# -lt 1 ]]; then
	echo "$0: BUILD_TYPE"
	exit 1
fi

BUILD_TYPE="$1"
BUILD_PATH="/tmp/libcpuid"

echo "Install packages"
case "$ID" in
	freebsd)
		sudo pkg install -y \
			cmake \
			ninja \
			git
		;;
	ubuntu)
		sudo apt-get install -y -qq \
			cmake \
			ninja-build \
			git \
			g++
		;;
	*)
		echo "$ID is not supported by $0."
		exit 1
esac


echo "Clone libcpuid Git repository"
git clone https://github.com/anrieff/libcpuid.git "$BUILD_PATH"
cd "$BUILD_PATH"

echo "Run CMake"
cmake -B build \
	-GNinja \
	-DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DBUILD_SHARED_LIBS=OFF

echo "Build libcpuid"
cmake --build build

echo "Install libcpuid on system"
sudo ninja -C build install
