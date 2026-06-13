# Arch Linux + Hyprland 初始化脚本

本仓库包含一套自动化的初始化脚本，用于在 **Arch Linux** 上快速部署功能完善的 **Hyprland** 环境。它涵盖了系统更新、软件包安装、Dotfiles 部署和服务配置等全流程。

> [!WARNING]
> 本脚本专为**Arch Linux**设计。它会修改系统配置和用户点文件（Dotfiles），请在运行前仔细阅读脚本内容。

## ✨ 功能特性

- **基于优秀的 Dotfiles**：本仓库配置基于 [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)。
- **自动化环境配置**：配置 pacman 镜像源并安装 `paru` (AUR 助手)。
- **软件包安装**：
  - **核心组件**：基础包、字体、实用工具。
  - **硬件自动检测**：自动识别 GPU (NVIDIA/AMD) 并安装相应的驱动程序。
  - **CPU 微码**：自动检测 Intel/AMD CPU 并安装微码。
  - **可选组件**：开发工具 (`code`)、虚拟化支持 (`qemu`) 和 额外应用 (`apps`)。
- **服务配置**：
  - NetworkManager (网络管理)
  - Bluetooth (蓝牙)
  - Libvirt / QEMU / KVM (虚拟化)
  - Docker (容器)
  - Samba (文件共享)
- **幂等性设计**：支持多次运行，可用于系统初始化及后续配置更新。
- **额外功能**：包含用于 CachyOS 内核优化的脚本 (位于 `extra/`)。

## 🚀 使用指南

### 适用场景
- **全新安装**：在刚刚安装好的 Arch Linux 系统上快速部署环境。
- **配置更新**：在已有环境上重新运行以同步最新的配置和软件包。

### 预备条件
- **Arch Linux** 系统。
- 互联网连接。
- 已安装 **Git** (`sudo pacman -S git`)。
- 一个具有 `sudo` 权限的普通用户。

### 安装步骤

1.  **克隆仓库**：
    ```bash
    git clone https://github.com/satori-5423/hyprland-init.git
    cd hyprland-init/
    ```

2.  **运行初始化脚本**：
    ```bash
    ./init.sh
    ```

3.  **跟随提示操作**：
    - 脚本运行过程中会请求 `sudo` 密码。
    - 根据提示选择是否安装可选组件。

4.  **重启**：
    若是首次安装，建议完成后重启系统。
    ```bash
    sudo reboot
    ```

## 📂 项目结构

- `init.sh`: 主入口脚本。
- `scripts/`:
  - `set-env.sh`: 设置系统基本环境。
  - `install.sh`: 安装软件包和驱动。
  - `config.sh`: 复制用户配置文件。
  - `start-service.sh`: 启动各种 Systemd 服务。
- `pkgs/`: 按类型分类的软件包列表。
- `configs/`: 预设的配置文件。
- `extra/`: 额外配置。

## ⚡ 额外内容：CachyOS 内核

如果您想使用优化过的 CachyOS 内核及软件源：
```bash
./extra/cachyos/set-cachy.sh
```
*风险提示：此操作会修改 pacman.conf 并添加第三方软件源，请按需使用。*
