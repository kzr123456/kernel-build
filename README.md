# Android 4.9.148 Kernel Build Project

这个项目使用GitHub Actions自动编译Android 4.9.148 kernel，源码来自 [Venice-AL00-TL00-L22_PIE_EMUI9.0.1](https://github.com/kzr123456/Venice-AL00-TL00-L22_PIE_EMUI9.0.1) 仓库。

## 项目特性

- 🚀 自动化编译流程
- 📱 支持Android 4.9.148 kernel
- 🔧 使用GitHub Actions进行CI/CD
- 📦 自动生成编译产物
- 🎯 针对Huawei Nova设备优化
- ⚙️ 使用merge_kirin970_defconfig配置

## 使用方法

1. Fork 这个仓库
2. 在GitHub仓库设置中启用Actions
3. 推送代码到main分支，GitHub Actions将自动开始编译
4. 在Actions标签页查看编译进度和结果

## 编译产物

编译完成后，你可以在Actions的Artifacts中找到：
- `Image` - 编译好的kernel镜像
- `dtbo.img` - Device tree overlay镜像
- `modules.tar.gz` - Kernel模块
- 编译日志和错误信息

## 系统要求

- Ubuntu 22.04 LTS (GitHub Actions运行环境)
- ARM64交叉编译工具链
- 必要的构建依赖包

## 许可证

本项目遵循原kernel源码的许可证。

## 贡献

欢迎提交Issue和Pull Request来改进这个项目。
