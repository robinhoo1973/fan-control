# Fan Control Daemon for ARM SoC

[English](#english) | [中文](#中文)

---

## English

### Project Description
A complete, intelligent fan control daemon for ARM-based Single Board Computers (SBC) and SoC devices running Debian-based systems. This script provides automatic temperature monitoring, dynamic fan speed adjustment, and an interactive configuration interface.

**Key Features:**
- 🔍 **Automatic Hardware Detection**: Intelligently detects fan speed range (0-255, 0-4, or other ranges)
- 🌡️ **Temperature Monitoring**: Supports multiple thermal zones with real-time monitoring
- ⚙️ **Interactive Configuration**: User-friendly menu for setting thresholds and parameters
- 🛡️ **Safety Features**: Temperature warnings and safe fallback mechanisms
- 📊 **Visual Interface**: Real-time status display with progress bars and color coding
- 🔧 **Complete Toolset**: Installation, configuration, monitoring, and testing commands

### Installation

```bash
# Download the script
wget -O fan-control.sh https://raw.githubusercontent.com/yourusername/fan-control/main/fan-control.sh
chmod +x fan-control.sh

# Install with automatic fan range detection
sudo ./fan-control.sh install
```

The installer will:
1. Check system requirements (Debian-based, ARM SoC)
2. Install dependencies
3. Detect your fan's speed range automatically
4. Create configuration files
5. Set up and start the systemd service

### Quick Start

```bash
# Check system status
fan-control status

# Interactive configuration
sudo fan-control menu-config

# Real-time monitoring
fan-control monitor

# Test hardware detection
fan-control test

# View logs
sudo fan-control log
```

### Available Commands

| Command | Description | Requires Root |
|---------|-------------|---------------|
| `install` | Install the fan control daemon | Yes |
| `uninstall` | Remove the daemon and related files | Yes |
| `start` | Start the fan control daemon | Yes |
| `stop` | Stop the daemon | Yes |
| `restart` | Restart the daemon | Yes |
| `status` | Show detailed system status | No |
| `monitor` | Real-time temperature/fan monitoring | No |
| `config` | Edit configuration file directly | Yes |
| `menu-config` | Interactive configuration menu | Yes |
| `log` | View live log output | No |
| `test` | Test hardware detection | No |
| `fan-stop` | Safely stop the fan completely | Yes |
| `fan-start` | Start fan control with safety checks | Yes |
| `detect` | Manually detect fan speed range | Yes |
| `help` | Show help information | No |

### Configuration

The main configuration file is located at `/etc/fan-control.conf` with the following key parameters:

```bash
# Temperature thresholds (Celsius)
HIGH_TEMP=65      # Fan runs at max speed above this temperature
LOW_TEMP=50       # Fan runs at min speed below this temperature

# Fan speed range (automatically detected)
MIN_SPEED=80      # Minimum fan speed
MAX_SPEED=255     # Maximum fan speed

# Control settings
CHECK_INTERVAL=5  # Temperature check interval in seconds
AUTO_CONTROL=1    # 1=Automatic control, 0=Manual control
MANUAL_SPEED=150  # Fixed speed when in manual mode
```

### How It Works

1. **Hardware Detection**: The script automatically detects available thermal zones and cooling devices
2. **Range Detection**: During installation, it tests and determines the actual fan speed range
3. **Temperature Monitoring**: Continuously reads temperatures from all thermal sensors
4. **Speed Calculation**: Uses linear interpolation between LOW_TEMP and HIGH_TEMP thresholds
5. **Fan Control**: Adjusts fan speed based on the highest detected temperature

### Supported Systems

- **Operating Systems**: Debian, Ubuntu, Armbian, Raspberry Pi OS
- **Architectures**: ARM-based SoC (Raspberry Pi, Orange Pi, Rockchip, Allwinner, etc.)
- **Kernel Requirements**: Linux kernel with sysfs thermal interface

### Advanced Usage

#### Manual Fan Range Detection
```bash
# Force re-detection of fan speed range
sudo fan-control detect
```

#### Custom Configuration
```bash
# Edit configuration manually
sudo fan-control config

# Or use the interactive menu
sudo fan-control menu-config
```

#### Service Management
```bash
# Check service status
systemctl status fan-control

# Enable auto-start on boot
systemctl enable fan-control

# View system logs
journalctl -u fan-control -f
```

### Troubleshooting

**No fan device detected?**
- Check if your system has `/sys/class/thermal/cooling_device*`
- Ensure you have appropriate kernel modules loaded
- Some systems may use different paths (e.g., `/sys/class/hwmon/`)

**Permission denied errors?**
- Most commands require root privileges
- Use `sudo` for installation, configuration, and control commands

**Temperature readings inaccurate?**
- Some sensors report values in millidegrees (automatically converted)
- Check `/sys/class/thermal/thermal_zone*/temp` manually

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### License

This project is licensed under the MIT License - see the LICENSE file for details.

### Acknowledgments

- Linux kernel thermal subsystem documentation
- Various ARM SBC community forums and resources
- All contributors and testers of this project

---

## 中文

### 项目描述
一个完整的、智能的风扇控制守护进程，专为基于ARM的单板计算机（SBC）和SoC设备设计，运行在基于Debian的系统上。本脚本提供自动温度监控、动态风扇速度调节和交互式配置界面。

**主要特性：**
- 🔍 **自动硬件检测**：智能检测风扇速度范围（0-255、0-4或其他范围）
- 🌡️ **温度监控**：支持多个热区实时监控
- ⚙️ **交互式配置**：用户友好的菜单界面设置阈值和参数
- 🛡️ **安全特性**：温度警告和安全回退机制
- 📊 **可视化界面**：实时状态显示，带有进度条和彩色编码
- 🔧 **完整工具集**：安装、配置、监控和测试命令

### 安装

```bash
# 下载脚本
wget -O fan-control.sh https://raw.githubusercontent.com/yourusername/fan-control/main/fan-control.sh
chmod +x fan-control.sh

# 安装并自动检测风扇范围
sudo ./fan-control.sh install
```

安装程序将：
1. 检查系统要求（基于Debian，ARM SoC）
2. 安装依赖包
3. 自动检测您的风扇速度范围
4. 创建配置文件
5. 设置并启动systemd服务

### 快速开始

```bash
# 检查系统状态
fan-control status

# 交互式配置
sudo fan-control menu-config

# 实时监控
fan-control monitor

# 测试硬件检测
fan-control test

# 查看日志
sudo fan-control log
```

### 可用命令

| 命令 | 描述 | 需要root权限 |
|------|------|--------------|
| `install` | 安装风扇控制守护进程 | 是 |
| `uninstall` | 移除守护进程和相关文件 | 是 |
| `start` | 启动风扇控制守护进程 | 是 |
| `stop` | 停止守护进程 | 是 |
| `restart` | 重启守护进程 | 是 |
| `status` | 显示详细系统状态 | 否 |
| `monitor` | 实时温度/风扇监控 | 否 |
| `config` | 直接编辑配置文件 | 是 |
| `menu-config` | 交互式配置菜单 | 是 |
| `log` | 查看实时日志输出 | 否 |
| `test` | 测试硬件检测 | 否 |
| `fan-stop` | 安全地完全停止风扇 | 是 |
| `fan-start` | 安全检查后启动风扇控制 | 是 |
| `detect` | 手动检测风扇速度范围 | 是 |
| `help` | 显示帮助信息 | 否 |

### 配置说明

主配置文件位于 `/etc/fan-control.conf`，包含以下关键参数：

```bash
# 温度阈值（摄氏度）
HIGH_TEMP=65      # 高于此温度时风扇全速运行
LOW_TEMP=50       # 低于此温度时风扇最低速运行

# 风扇速度范围（自动检测）
MIN_SPEED=80      # 最低风扇速度
MAX_SPEED=255     # 最高风扇速度

# 控制设置
CHECK_INTERVAL=5  # 温度检查间隔（秒）
AUTO_CONTROL=1    # 1=自动控制，0=手动控制
MANUAL_SPEED=150  # 手动模式下的固定速度
```

### 工作原理

1. **硬件检测**：脚本自动检测可用的热区和冷却设备
2. **范围检测**：安装期间测试并确定实际的风扇速度范围
3. **温度监控**：持续从所有温度传感器读取温度
4. **速度计算**：在LOW_TEMP和HIGH_TEMP阈值之间使用线性插值
5. **风扇控制**：根据检测到的最高温度调整风扇速度

### 支持系统

- **操作系统**：Debian、Ubuntu、Armbian、Raspberry Pi OS
- **架构**：基于ARM的SoC（树莓派、香橙派、瑞芯微、全志等）
- **内核要求**：支持sysfs热接口的Linux内核

### 高级用法

#### 手动风扇范围检测
```bash
# 强制重新检测风扇速度范围
sudo fan-control detect
```

#### 自定义配置
```bash
# 手动编辑配置
sudo fan-control config

# 或使用交互式菜单
sudo fan-control menu-config
```

#### 服务管理
```bash
# 检查服务状态
systemctl status fan-control

# 启用开机自启
systemctl enable fan-control

# 查看系统日志
journalctl -u fan-control -f
```

### 故障排除

**未检测到风扇设备？**
- 检查系统是否有 `/sys/class/thermal/cooling_device*`
- 确保加载了适当的内核模块
- 某些系统可能使用不同的路径（例如 `/sys/class/hwmon/`）

**权限被拒绝错误？**
- 大多数命令需要root权限
- 安装、配置和控制命令请使用 `sudo`

**温度读数不准确？**
- 某些传感器以毫摄氏度报告值（已自动转换）
- 手动检查 `/sys/class/thermal/thermal_zone*/temp`

### 贡献指南

欢迎贡献！请随时提交Pull Request。

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个Pull Request

### 许可证

本项目采用MIT许可证 - 查看LICENSE文件了解详情。

### 致谢

- Linux内核热管理子系统文档
- 各种ARM SBC社区论坛和资源
- 本项目的所有贡献者和测试者

---
