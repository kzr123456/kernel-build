# Android 4.9.148 Kernel Build Project Makefile
# Provides convenient build commands for the project

.PHONY: help setup build clean distclean artifacts

# Default target
help:
	@echo "Android 4.9.148 Kernel Build Project"
	@echo "===================================="
	@echo ""
	@echo "Available targets:"
	@echo "  setup      - Setup build environment and toolchain"
	@echo "  build      - Build the kernel"
	@echo "  clean      - Clean build artifacts"
	@echo "  distclean  - Clean everything including toolchain"
	@echo "  artifacts  - Show build artifacts"
	@echo "  help       - Show this help message"
	@echo ""
	@echo "Usage examples:"
	@echo "  make setup    # First time setup"
	@echo "  make build    # Build kernel"
	@echo "  make clean    # Clean build files"

# Setup build environment
setup:
	@echo "Setting up build environment..."
	@chmod +x build-scripts/setup-toolchain.sh
	@chmod +x build-scripts/build-kernel.sh
	@chmod +x build-scripts/setup-env.sh
	@./build-scripts/setup-toolchain.sh
	@echo "Setup completed successfully!"

# Build kernel
build: setup
	@echo "Building kernel..."
	@./build-scripts/build-kernel.sh

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/artifacts
	@rm -rf build/kernel-source
	@echo "Clean completed!"

# Clean everything including toolchain
distclean: clean
	@echo "Cleaning everything including toolchain..."
	@rm -rf build/
	@rm -rf toolchain/
	@echo "Distclean completed!"

# Show build artifacts
artifacts:
	@if [ -d "build/artifacts" ]; then \
		echo "Build artifacts:"; \
		ls -la build/artifacts/; \
	else \
		echo "No build artifacts found. Run 'make build' first."; \
	fi

# Quick build (setup + build)
all: setup build
