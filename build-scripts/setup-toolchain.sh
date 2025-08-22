#!/bin/bash

# Android 4.9.148 Kernel Build Toolchain Setup Script
# This script sets up the ARM64 cross-compilation toolchain

set -e

echo "Setting up ARM64 cross-compilation toolchain..."

# Create toolchain directory
TOOLCHAIN_DIR="$(pwd)/toolchain"
mkdir -p "$TOOLCHAIN_DIR"
cd "$TOOLCHAIN_DIR"

# Download Linaro GCC 7.5.0 ARM64 toolchain
TOOLCHAIN_URL="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz"
TOOLCHAIN_FILE="gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz"

echo "Downloading Linaro GCC 7.5.0 ARM64 toolchain..."
if [ ! -f "$TOOLCHAIN_FILE" ]; then
    wget "$TOOLCHAIN_URL" -O "$TOOLCHAIN_FILE"
else
    echo "Toolchain already downloaded."
fi

# Extract toolchain
echo "Extracting toolchain..."
tar -xf "$TOOLCHAIN_FILE"

# Set environment variables
export PATH="$TOOLCHAIN_DIR/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin:$PATH"
export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64

echo "Toolchain setup complete!"
echo "Environment variables set:"
echo "  PATH: $PATH"
echo "  CROSS_COMPILE: $CROSS_COMPILE"
echo "  ARCH: $ARCH"

# Verify toolchain
echo "Verifying toolchain..."
aarch64-linux-gnu-gcc --version

echo "Setup completed successfully!"
