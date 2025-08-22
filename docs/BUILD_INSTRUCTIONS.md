# Android 4.9.148 Kernel 构建说明

## 概述

本项目使用GitHub Actions自动编译Android 4.9.148 kernel，源码来自Huawei Nova设备的kernel仓库。

## 构建方式

### 方式1: GitHub Actions (推荐)

1. Fork本仓库
2. 启用GitHub Actions
3. 推送代码到main分支
4. 在Actions标签页查看构建进度

### 方式2: 本地构建

#### 系统要求
- Ubuntu 22.04+ 或类似Linux发行版
- 至少8GB RAM
- 至少20GB可用磁盘空间

#### 安装依赖
```bash
sudo apt-get update
sudo apt-get install -y \
  build-essential git wget curl python3 python3-pip \
  bc flex bison libssl-dev libncurses5-dev libncursesw5-dev \
  libelf-dev libdw-dev libslang2-dev libperl-dev pkg-config \
  libudev-dev libpci-dev libiberty-dev autoconf automake \
  libtool cmake gawk rsync kmod cpio unzip zip xz-utils lz4 zstd
```

#### 构建步骤
```bash
# 克隆项目
git clone <your-repo-url>
cd <repo-name>

# 设置构建环境
make setup

# 构建kernel
make build

# 查看构建产物
make artifacts
```

## 构建产物

构建完成后，在`build/artifacts/`目录下可以找到：
- `Image` - 编译好的kernel镜像
- `dtbo.img` - Device tree overlay镜像
- `modules.tar.gz` - Kernel模块压缩包

## 故障排除

### 常见问题

1. **工具链下载失败**
   - 检查网络连接
   - 手动下载工具链并放置到toolchain目录

2. **编译错误**
   - 检查依赖包是否完整安装
   - 查看构建日志获取详细错误信息

3. **内存不足**
   - 减少并行编译任务数量
   - 增加swap空间

### 获取帮助

如遇到问题，请：
1. 查看GitHub Actions构建日志
2. 提交Issue描述问题
3. 检查README.md中的常见问题解答
