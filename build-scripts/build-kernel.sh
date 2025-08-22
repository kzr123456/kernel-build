#!/bin/bash

# Android 4.9.148 Kernel Build Script
# This script builds the kernel from source

set -e

# Configuration
KERNEL_SOURCE_URL="https://github.com/kzr123456/Venice-AL00-TL00-L22_PIE_EMUI9.0.1.git"
KERNEL_BRANCH="main"
BUILD_DIR="$(pwd)/build"
SOURCE_DIR="$BUILD_DIR/kernel-source"
TOOLCHAIN_DIR="$(pwd)/toolchain"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check dependencies
check_dependencies() {
    log "Checking build dependencies..."
    
    local deps=("git" "wget" "make" "gcc" "bc" "flex" "bison" "libssl-dev")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            error "Dependency not found: $dep"
            exit 1
        fi
    done
    
    # Check for GCC-9 specifically to avoid DTC compilation issues
    if ! command -v gcc-9 &> /dev/null; then
        warning "GCC-9 not found. DTC compilation may fail."
        warning "Consider installing gcc-9: sudo apt-get install gcc-9 g++-9"
    fi
    
    log "All dependencies are available."
}

# Setup build environment
setup_build_env() {
    log "Setting up build environment..."
    
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    
    # Source toolchain environment
    if [ -f "$TOOLCHAIN_DIR/setup-env.sh" ]; then
        source "$TOOLCHAIN_DIR/setup-env.sh"
    fi
    
    # Set environment variables
    export PATH="$TOOLCHAIN_DIR/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin:$PATH"
    export CROSS_COMPILE=aarch64-linux-gnu-
    export ARCH=arm64
    
    # Set GCC-9 for host tools to avoid DTC compilation issues
    if command -v gcc-9 &> /dev/null; then
        export HOSTCC=gcc-9
        export HOSTCXX=g++-9
        export CC=gcc-9
        export CXX=g++-9
        log "Using GCC-9 for host tools compilation."
    else
        warning "GCC-9 not available, using default GCC."
    fi
    
    log "Build environment setup complete."
}

# Clone kernel source
clone_source() {
    log "Cloning kernel source from $KERNEL_SOURCE_URL..."
    
    if [ -d "$SOURCE_DIR" ]; then
        log "Source directory already exists, updating..."
        cd "$SOURCE_DIR"
        git fetch origin
        git reset --hard origin/$KERNEL_BRANCH
    else
        git clone --depth=1 --branch="$KERNEL_BRANCH" "$KERNEL_SOURCE_URL" "$SOURCE_DIR"
    fi
    
    cd "$SOURCE_DIR"
    log "Kernel source ready at: $SOURCE_DIR"
}

# Configure kernel
configure_kernel() {
    log "Configuring kernel..."
    
    cd "$SOURCE_DIR"
    
    # Use merge_kirin970_defconfig if available
    if [ -f "arch/arm64/configs/merge_kirin970_defconfig" ]; then
        make merge_kirin970_defconfig
        log "Using merge_kirin970_defconfig configuration."
    else
        warning "merge_kirin970_defconfig not found, trying defconfig..."
        if [ -f "arch/arm64/configs/defconfig" ]; then
            make defconfig
            log "Using defconfig configuration."
        else
            warning "No defconfig found, using default configuration."
            make menuconfig || make oldconfig || true
        fi
    fi
    
    log "Kernel configuration complete."
}

# Build kernel
build_kernel() {
    log "Building kernel..."
    
    cd "$SOURCE_DIR"
    
    # Get number of CPU cores for parallel build
    local cores=$(nproc)
    log "Building with $cores parallel jobs..."
    
    # Build kernel image and modules
    make -j"$cores" Image modules
    
    log "Kernel build completed successfully!"
}

# Package artifacts
package_artifacts() {
    log "Packaging build artifacts..."
    
    cd "$SOURCE_DIR"
    
    local artifacts_dir="$BUILD_DIR/artifacts"
    mkdir -p "$artifacts_dir"
    
    # Copy kernel image
    if [ -f "arch/arm64/boot/Image" ]; then
        cp "arch/arm64/boot/Image" "$artifacts_dir/"
        log "Kernel image copied: $artifacts_dir/Image"
    else
        error "Kernel image not found!"
    fi
    
    # Copy dtbo image if available
    if [ -f "arch/arm64/boot/dtbo.img" ]; then
        cp "arch/arm64/boot/dtbo.img" "$artifacts_dir/"
        log "DTBO image copied: $artifacts_dir/dtbo.img"
    else
        log "DTBO image not found, skipping..."
    fi
    
    # Package kernel modules
    if [ -d "modules" ] || find . -name "*.ko" -print -quit | grep -q .; then
        find . -name "*.ko" -exec tar -czf "$artifacts_dir/modules.tar.gz" {} + 2>/dev/null || true
        log "Kernel modules packaged: $artifacts_dir/modules.tar.gz"
    else
        warning "No kernel modules found."
    fi
    
    # Copy build log
    if [ -f "build.log" ]; then
        cp "build.log" "$artifacts_dir/"
    fi
    
    log "Artifacts packaged in: $artifacts_dir"
}

# Main build function
main() {
    log "Starting Android 4.9.148 kernel build..."
    
    check_dependencies
    setup_build_env
    clone_source
    configure_kernel
    build_kernel
    package_artifacts
    
    log "Build completed successfully!"
    log "Artifacts available in: $BUILD_DIR/artifacts"
}

# Run main function
main "$@"
