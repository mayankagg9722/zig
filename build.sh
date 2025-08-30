#!/usr/bin/env bash
set -euo pipefail

# --- CONFIG ---
LLVM_VERSION=20

echo "[*] Updating system packages..."
apt-get update -y

echo "[*] Installing build essentials (gcc, g++, make, etc.)..."
apt-get install -y build-essential software-properties-common wget gnupg lsb-release

echo "[*] Installing CMake (>=3.15)..."
apt-get install -y cmake
cmake_version=$(cmake --version | head -n1 | awk '{print $3}')
echo "[+] Installed CMake version: $cmake_version"

echo "[*] Installing GCC/G++ (>=7.0.0)..."
apt-get install -y gcc g++
gcc_version=$(gcc -dumpversion)
echo "[+] Installed GCC version: $gcc_version"

echo "[*] Adding official LLVM apt repo..."
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
./llvm.sh $LLVM_VERSION
rm llvm.sh

echo "[*] Installing LLVM/Clang/LLD development packages..."
apt-get install -y \
    llvm-$LLVM_VERSION-dev \
    clang-$LLVM_VERSION \
    clang-tools-$LLVM_VERSION \
    libclang-$LLVM_VERSION-dev \
    lld-$LLVM_VERSION \
    liblld-$LLVM_VERSION-dev

echo "[*] Setting LLVM_CONFIG environment variable..."
export LLVM_CONFIG=/usr/bin/llvm-config-$LLVM_VERSION

echo
echo "============================================================"
echo "✅ Environment setup complete!"
echo " - CMake version: $(cmake --version | head -n1)"
echo " - GCC version:   $(gcc -dumpversion)"
echo " - LLVM version:  $($LLVM_CONFIG --version)"
echo " - Clang includes: /usr/lib/llvm-$LLVM_VERSION/include/clang"
echo " - LLD includes:   /usr/lib/llvm-$LLVM_VERSION/include/lld"
echo
echo "You may want to add this line to your ~/.bashrc:"
echo "    export LLVM_CONFIG=/usr/bin/llvm-config-$LLVM_VERSION"
echo "============================================================"



mkdir build
cd build
cmake ..
make install

