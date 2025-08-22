#!/bin/bash

# Environment setup script for Android 4.9.148 kernel build
# Source this script to set up the build environment

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLCHAIN_DIR="$(dirname "$SCRIPT_DIR")"

# Set ARM64 cross-compilation environment
export PATH="$TOOLCHAIN_DIR/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin:$PATH"
export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64

# Additional build environment variables
export KBUILD_BUILD_USER="github-actions"
export KBUILD_BUILD_HOST="github-actions"
export LOCALVERSION="-github-build"

# Display environment information
echo "Android 4.9.148 Kernel Build Environment Setup"
echo "=============================================="
echo "TOOLCHAIN_DIR: $TOOLCHAIN_DIR"
echo "PATH: $PATH"
echo "CROSS_COMPILE: $CROSS_COMPILE"
echo "ARCH: $ARCH"
echo "KBUILD_BUILD_USER: $KBUILD_BUILD_USER"
echo "KBUILD_BUILD_HOST: $KBUILD_BUILD_HOST"
echo "LOCALVERSION: $LOCALVERSION"
echo "=============================================="

# Verify toolchain
if command -v aarch64-linux-gnu-gcc &> /dev/null; then
    echo "✓ ARM64 toolchain found:"
    aarch64-linux-gnu-gcc --version | head -1
else
    echo "✗ ARM64 toolchain not found in PATH"
    echo "Please run setup-toolchain.sh first"
fi
