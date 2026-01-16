#!/bin/bash

# ============================================
# 完整风扇控制守护进程
# Complete Fan Control Daemon
# 版本: 5.0 (完整功能版)
# ============================================

# 语言设置
# 全局语言相关变量
LANG="en"  # 默认语言
declare -A MSG
LANG_SET_BY_CLI=0  # 标记是否通过命令行参数设置语言

# 英文消息
declare -A EN_MSG=(
    ["title"]="Complete Fan Control Daemon v5.0"
    ["install_title"]="Fan Control Installation"
    ["uninstall_title"]="Fan Control Uninstallation"
    ["checking_root"]="Checking root privileges..."
    ["root_required"]="This script must be run as root!"
    ["detecting_os"]="Detecting operating system..."
    ["unsupported_os"]="Unsupported OS. Requires Debian-based system."
    ["installing_deps"]="Installing dependencies..."
    ["creating_files"]="Creating system files..."
    ["config_created"]="Configuration file created"
    ["service_created"]="Systemd service created"
    ["setting_perms"]="Setting permissions..."
    ["reloading_systemd"]="Reloading systemd..."
    ["enabling_service"]="Enabling service..."
    ["starting_service"]="Starting service..."
    ["installation_complete"]="Installation complete!"
    ["usage"]="Usage: fan-control [command]"
    ["commands"]="Commands:"
    ["cmd_install"]="  install       Install fan control daemon"
    ["cmd_uninstall"]="  uninstall     Uninstall fan control daemon"
    ["cmd_start"]="  start         Start daemon"
    ["cmd_stop"]="  stop          Stop daemon"
    ["cmd_restart"]="  restart       Restart daemon"
    ["cmd_status"]="  status        Show detailed status"
    ["cmd_monitor"]="  monitor       Real-time monitoring"
    ["cmd_config"]="  config        Edit configuration file"
    ["cmd_menuconfig"]="  menu-config    Interactive configuration menu"
    ["cmd_log"]="  log           View logs"
    ["cmd_test"]="  test          Test hardware"
    ["cmd_fanstop"]="  fan-stop      Stop fan completely"
    ["cmd_fanstart"]="  fan-start     Start fan control"
    ["cmd_detect"]="  detect        Detect fan speed range"
    ["cmd_help"]="  help          Show this help"
    ["service_running"]="Service is running"
    ["service_stopped"]="Service is stopped"
    ["daemon_started"]="Daemon started"
    ["daemon_stopped"]="Daemon stopped"
    ["daemon_restarted"]="Daemon restarted"
    ["config_updated"]="Configuration updated"
    ["view_logs"]="Viewing logs..."
    ["testing_hardware"]="Testing hardware..."
    ["uninstall_confirm"]="Are you sure you want to uninstall? (y/n): "
    ["uninstalling"]="Uninstalling..."
    ["service_stopped_uninstall"]="Service stopped"
    ["files_removed"]="Files removed"
    ["uninstall_complete"]="Uninstallation complete"
    ["keep_config"]="Keep configuration file? (y/n): "
    ["install_aborted"]="Installation aborted"
    ["existing_install"]="Existing installation found"
    ["overwrite_prompt"]="Overwrite existing installation? (y/n): "
    ["skip_uninstall"]="Skipping uninstall"
    ["select_lang"]="Select language (选择语言):"
    ["lang_en"]="1. English (英文)"
    ["lang_cn"]="2. 中文 (Chinese)"
    ["invalid_lang"]="Invalid selection, using English"
    ["fan_stopped"]="Fan stopped (speed set to 0)"
    ["fan_started"]="Fan control started"
    ["config_menu"]="Configuration Menu"
    ["config_exit"]="Exit and save configuration"
    ["config_saved"]="Configuration saved successfully"
    ["config_restart_hint"]="Restart service for changes to take effect: sudo fan-control restart"
    ["config_item"]="Config Item"
    ["current_value"]="Current Value"
    ["description"]="Description"
    ["recommended"]="Recommended"
    ["enter_new_value"]="Enter new value (press Enter to keep current): "
    ["invalid_input"]="Invalid input, keeping current value"
    ["temp_too_high"]="Warning: Temperature is too high! Stopping fan may cause overheating."
    ["confirm_fan_stop"]="Are you sure you want to stop the fan? (y/n): "
    ["temp_warning_threshold"]="Warning threshold: 70°C"
    ["detect_start"]="Starting fan speed range detection..."
    ["detect_warning"]="WARNING: The fan may start or stop during this test."
    ["detect_cancelled"]="Detection cancelled. Using safe defaults (0-255)."
    ["detect_testing_max"]="Testing maximum speed (255)..."
    ["detect_reported"]="System reported speed after setting 255: "
    ["detect_standard_range"]="✓ Standard 0-255 PWM range detected."
    ["detect_limited_range"]="✓ Limited range detected (0-"
    ["detect_unique_range"]="? Unique range detected, max is "
    ["detect_testing_small"]="255 not accepted, testing small range..."
    ["detect_max_level"]="✓ Maximum speed level detected: "
    ["detect_testing_min"]="Testing minimum speed (0)..."
    ["detect_min_level"]="✓ Minimum speed level: "
    ["detect_set_safe"]="Fan set to safe speed: "
    ["detect_complete"]="Detection complete: Speed range is "
    ["detect_already_done"]="Fan range already detected: "
    ["detect_use_cache"]="Using cached fan range."
    ["range_cache_file"]="/tmp/fan_range.cache"
    ["no_fan_device"]="No fan device found for detection"
)

# 中文消息
declare -A CN_MSG=(
    ["title"]="完整风扇控制守护进程 v5.0"
    ["install_title"]="风扇控制安装程序"
    ["uninstall_title"]="风扇控制卸载程序"
    ["checking_root"]="检查root权限..."
    ["root_required"]="必须使用root权限运行此脚本！"
    ["detecting_os"]="检测操作系统..."
    ["unsupported_os"]="不支持的操作系统，需要基于Debian的系统"
    ["installing_deps"]="安装依赖包..."
    ["creating_files"]="创建系统文件..."
    ["config_created"]="配置文件已创建"
    ["service_created"]="Systemd服务文件已创建"
    ["setting_perms"]="设置权限..."
    ["reloading_systemd"]="重新加载systemd..."
    ["enabling_service"]="启用服务..."
    ["starting_service"]="启动服务..."
    ["installation_complete"]="安装完成！"
    ["usage"]="用法: fan-control [命令]"
    ["commands"]="命令列表:"
    ["cmd_install"]="  install       安装风扇控制守护进程"
    ["cmd_uninstall"]="  uninstall     卸载风扇控制守护进程"
    ["cmd_start"]="  start         启动守护进程"
    ["cmd_stop"]="  stop          停止守护进程"
    ["cmd_restart"]="  restart       重启守护进程"
    ["cmd_status"]="  status        显示详细状态"
    ["cmd_monitor"]="  monitor       实时监控模式"
    ["cmd_config"]="  config        编辑配置文件"
    ["cmd_menuconfig"]="  menu-config    交互式配置菜单"
    ["cmd_log"]="  log           查看日志"
    ["cmd_test"]="  test          测试硬件"
    ["cmd_fanstop"]="  fan-stop      完全停止风扇"
    ["cmd_fanstart"]="  fan-start     启动风扇控制"
    ["cmd_detect"]="  detect        检测风扇速度范围"
    ["cmd_help"]="  help          显示帮助信息"
    ["service_running"]="服务正在运行"
    ["service_stopped"]="服务已停止"
    ["daemon_started"]="守护进程已启动"
    ["daemon_stopped"]="守护进程已停止"
    ["daemon_restarted"]="守护进程已重启"
    ["config_updated"]="配置已更新"
    ["view_logs"]="查看日志..."
    ["testing_hardware"]="测试硬件..."
    ["uninstall_confirm"]="确定要卸载吗？(y/n): "
    ["uninstalling"]="正在卸载..."
    ["service_stopped_uninstall"]="服务已停止"
    ["files_removed"]="文件已移除"
    ["uninstall_complete"]="卸载完成"
    ["keep_config"]="保留配置文件吗？(y/n): "
    ["install_aborted"]="安装已取消"
    ["existing_install"]="发现已存在的安装"
    ["overwrite_prompt"]="覆盖已存在的安装吗？(y/n): "
    ["skip_uninstall"]="跳过卸载"
    ["select_lang"]="选择语言:"
    ["lang_en"]="1. 英文 (English)"
    ["lang_cn"]="2. 中文 (Chinese)"
    ["invalid_lang"]="无效选择，使用英文"
    ["fan_stopped"]="风扇已停止（速度设为0）"
    ["fan_started"]="风扇控制已启动"
    ["config_menu"]="配置菜单"
    ["config_exit"]="退出并保存配置"
    ["config_saved"]="配置保存成功"
    ["config_restart_hint"]="重启服务使更改生效: sudo fan-control restart"
    ["config_item"]="配置项"
    ["current_value"]="当前值"
    ["description"]="说明"
    ["recommended"]="推荐值"
    ["enter_new_value"]="输入新值（按Enter保持当前值）: "
    ["invalid_input"]="无效输入，保持当前值"
    ["temp_too_high"]="警告：温度过高！停止风扇可能导致过热。"
    ["confirm_fan_stop"]="确定要停止风扇吗？(y/n): "
    ["temp_warning_threshold"]="警告阈值: 70°C"
    ["detect_start"]="开始检测风扇速度范围..."
    ["detect_warning"]="警告：测试期间风扇可能会启动或停止。"
    ["detect_cancelled"]="检测已取消。使用安全默认值 (0-255)。"
    ["detect_testing_max"]="测试最大速度 (255)..."
    ["detect_reported"]="设置255后系统报告的速度: "
    ["detect_standard_range"]="✓ 检测到标准 0-255 PWM 范围。"
    ["detect_limited_range"]="✓ 检测到有限范围 (0-"
    ["detect_unique_range"]="? 检测到独特范围，最大值为 "
    ["detect_testing_small"]="255不被接受，测试小范围..."
    ["detect_max_level"]="✓ 检测到最大速度等级: "
    ["detect_testing_min"]="测试最小速度 (0)..."
    ["detect_min_level"]="✓ 最小速度等级: "
    ["detect_set_safe"]="风扇设置为安全速度: "
    ["detect_complete"]="检测完成：速度范围为 "
    ["detect_already_done"]="风扇范围已检测: "
    ["detect_use_cache"]="使用缓存的风扇范围。"
    ["range_cache_file"]="/tmp/fan_range.cache"
    ["no_fan_device"]="未找到风扇设备进行检测"
)

# 设置语言
set_language() {
    if [ "$LANG" = "cn" ]; then
        for key in "${!EN_MSG[@]}"; do
            MSG[$key]="${CN_MSG[$key]}"
        done
    else
        for key in "${!EN_MSG[@]}"; do
            MSG[$key]="${EN_MSG[$key]}"
        done
    fi
}

# 初始化语言（重新设计）
init_language() {
    # 第一步：设置默认语言
    LANG="en"
    set_language
    
    # 第二步：如果有配置文件，从配置文件加载语言设置（但此时不立即应用）
    if [ -f "$CONFIG_FILE" ]; then
        # 只读取LANGUAGE变量，不执行其他配置
        local config_lang=$(grep -E '^LANGUAGE="?(en|cn)"?' "$CONFIG_FILE" | cut -d'"' -f2)
        if [ -n "$config_lang" ]; then
            CONFIG_LANG="$config_lang"
        fi
    fi
    
    # 第三步：解析命令行参数
    local lang_from_cli=""
    for ((i=1; i<=$#; i++)); do
        local arg="${!i}"
        local next_arg=""
        if [ $i -lt $# ]; then
            next_arg="${@:$((i+1)):1}"
        fi
        
        if [ "$arg" = "--lang" ] || [ "$arg" = "-l" ]; then
            if [ -n "$next_arg" ]; then
                if [ "$next_arg" = "cn" ] || [ "$next_arg" = "zh" ]; then
                    lang_from_cli="cn"
                elif [ "$next_arg" = "en" ]; then
                    lang_from_cli="en"
                fi
            fi
        fi
    done
    
    # 第四步：按照优先级设置语言（命令行参数 > 配置文件 > 默认值）
    if [ -n "$lang_from_cli" ]; then
        LANG="$lang_from_cli"
        LANG_SET_BY_CLI=1
        set_language
        if [ "$LANG" = "cn" ]; then
            echo "已通过命令行参数设置语言为中文"
        else
            echo "Language set to English via command line"
        fi
    elif [ -n "$CONFIG_LANG" ]; then
        LANG="$CONFIG_LANG"
        set_language
    fi
}


# 显示消息
show_msg() {
    echo "${MSG[$1]}"
}

# 显示标题
show_title() {
    echo "================================================"
    echo "${MSG["title"]}"
    echo "================================================"
    echo ""
}

# 选择语言
select_language() {
    show_title
    show_msg "select_lang"
    echo ""
    show_msg "lang_en"
    show_msg "lang_cn"
    echo ""
    
    if [ "$LANG" = "cn" ]; then
        read -p "请选择 [1-2]: " lang_choice
    else
        read -p "Select [1-2]: " lang_choice
    fi
    
    case $lang_choice in
        1)
            LANG="en"
            ;;
        2)
            LANG="cn"
            ;;
        *)
            show_msg "invalid_lang"
            LANG="en"
            ;;
    esac
    
    set_language
}

# ============================================
# 安装相关配置
# ============================================

# 文件路径
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="/etc"
SERVICE_DIR="/etc/systemd/system"
LOG_DIR="/var/log"
SCRIPT_NAME="fan-control"
CONFIG_FILE="$CONFIG_DIR/$SCRIPT_NAME.conf"
SERVICE_FILE="$SERVICE_DIR/$SCRIPT_NAME.service"
LOG_FILE="$LOG_DIR/$SCRIPT_NAME.log"
PID_FILE="/var/run/$SCRIPT_NAME.pid"
RANGE_CACHE_FILE="/tmp/fan_range.cache"

# ============================================
# 风扇控制核心配置
# ============================================

# 默认配置
HIGH_TEMP=65
LOW_TEMP=50
CHECK_INTERVAL=5
MIN_SPEED=80
MAX_SPEED=255
ENABLE_LOGGING=1
LOG_LEVEL="INFO"
AUTO_CONTROL=1
MANUAL_SPEED=150
DETECTED_MIN=0
DETECTED_MAX=255

# 系统路径
THERMAL_ZONE_PATH="/sys/class/thermal"
COOLING_DEVICE_PATH="/sys/class/thermal"

# 全局变量
declare -a THERMAL_ZONES
declare -a COOLING_DEVICES
FAN_DEVICE=""
CURRENT_SPEED=0
DAEMON_MODE=0

# 颜色代码
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

# 固定分隔线长度
SEPARATOR_LENGTH=48
SEPARATOR=$(printf "=%.0s" $(seq 1 $SEPARATOR_LENGTH))

# ============================================
# 核心功能函数
# ============================================

#修改 load_config 函数，避免重复设置语言
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        # 如果是通过命令行参数设置的语言，就不从配置文件加载语言设置
        if [ $LANG_SET_BY_CLI -eq 0 ]; then
            source "$CONFIG_FILE"
            
            # 如果配置中有语言设置，且命令行没有设置，则应用配置中的语言
            if [ -n "$LANGUAGE" ]; then
                LANG="$LANGUAGE"
                set_language
            fi
        else
            # 命令行参数已设置语言，只加载其他配置，不覆盖语言
            # 临时保存当前语言
            local current_lang="$LANG"
            source "$CONFIG_FILE"
            # 恢复命令行设置的语言
            LANG="$current_lang"
            set_language
        fi
        
        # 加载检测到的风扇范围（如果存在）
        if [ -f "$RANGE_CACHE_FILE" ]; then
            source "$RANGE_CACHE_FILE"
            if [ -n "$FAN_MIN" ] && [ -n "$FAN_MAX" ]; then
                DETECTED_MIN=$FAN_MIN
                DETECTED_MAX=$FAN_MAX
                # 更新MIN_SPEED和MAX_SPEED为检测到的值
                MIN_SPEED=$FAN_MIN
                MAX_SPEED=$FAN_MAX
            fi
        fi
    fi
}


# 检测硬件
detect_hardware() {
    # 检测温度传感器
    if [ -d "$THERMAL_ZONE_PATH" ]; then
        THERMAL_ZONES=($(ls -d $THERMAL_ZONE_PATH/thermal_zone* 2>/dev/null | sort))
    fi
    
    # 检测风扇设备
    if [ -d "$COOLING_DEVICE_PATH" ]; then
        COOLING_DEVICES=($(ls -d $COOLING_DEVICE_PATH/cooling_device* 2>/dev/null | sort))
        
        # 查找风扇设备
        for device in "${COOLING_DEVICES[@]}"; do
            if [ -f "$device/type" ]; then
                type=$(cat "$device/type" 2>/dev/null)
                if [[ "$type" == *"fan"* ]] || [[ "$type" == *"Fan"* ]]; then
                    FAN_DEVICE="$device"
                    break
                fi
            fi
        done
        
        # 使用第一个冷却设备
        if [ -z "$FAN_DEVICE" ] && [ ${#COOLING_DEVICES[@]} -gt 0 ]; then
            FAN_DEVICE="${COOLING_DEVICES[0]}"
        fi
    fi
}

# 获取最高温度
get_max_temperature() {
    local max_temp=0
    local current_temp=0
    
    for zone in "${THERMAL_ZONES[@]}"; do
        if [ -f "$zone/temp" ]; then
            current_temp=$(cat "$zone/temp" 2>/dev/null)
            if [ $current_temp -gt 10000 ]; then
                current_temp=$((current_temp / 1000))
            fi
            
            if [ $current_temp -gt $max_temp ]; then
                max_temp=$current_temp
            fi
        fi
    done
    
    echo $max_temp
}

# 获取所有温度传感器
get_all_temperatures() {
    local temps=""
    for zone in "${THERMAL_ZONES[@]}"; do
        if [ -f "$zone/temp" ] && [ -f "$zone/type" ]; then
            zone_type=$(cat "$zone/type" 2>/dev/null)
            temp=$(cat "$zone/temp" 2>/dev/null)
            if [ $temp -gt 10000 ]; then
                temp=$((temp / 1000))
            fi
            temps+="$zone_type: ${temp}°C\n"
        fi
    done
    echo -e "$temps"
}

# 获取风扇状态
get_fan_status() {
    if [ -n "$FAN_DEVICE" ]; then
        if [ -f "$FAN_DEVICE/cur_state" ]; then
            cat "$FAN_DEVICE/cur_state" 2>/dev/null
        elif [ -f "$FAN_DEVICE/max_state" ]; then
            echo "0"
        else
            echo "N/A"
        fi
    else
        echo "N/A"
    fi
}

# 设置风扇速度
set_fan_speed() {
    local speed=$1
    
    if [ -n "$FAN_DEVICE" ]; then
        if [ -f "$FAN_DEVICE/cur_state" ]; then
            echo "$speed" > "$FAN_DEVICE/cur_state" 2>/dev/null
            if [ $? -eq 0 ]; then
                CURRENT_SPEED=$speed
                return 0
            else
                return 1
            fi
        elif [ -f "$FAN_DEVICE/max_state" ]; then
            return 1
        fi
    fi
    
    return 1
}

# 计算风扇速度
calculate_fan_speed() {
    local temp=$1
    local speed=$MIN_SPEED
    
    # 使用检测到的范围进行计算
    local actual_min=$MIN_SPEED
    local actual_max=$MAX_SPEED
    
    # 如果有检测到的范围，使用检测到的范围
    if [ -n "$DETECTED_MIN" ] && [ -n "$DETECTED_MAX" ]; then
        actual_min=$DETECTED_MIN
        actual_max=$DETECTED_MAX
    fi
    
    if [ $temp -ge $HIGH_TEMP ]; then
        speed=$actual_max
    elif [ $temp -gt $LOW_TEMP ] && [ $temp -lt $HIGH_TEMP ]; then
        local temp_range=$((HIGH_TEMP - LOW_TEMP))
        local speed_range=$((actual_max - actual_min))
        local temp_diff=$((temp - LOW_TEMP))
        
        speed=$((actual_min + (temp_diff * speed_range) / temp_range))
    else
        speed=$actual_min
    fi
    
    echo $speed
}

# 记录日志
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    if [ $ENABLE_LOGGING -eq 1 ]; then
        echo "$timestamp [$level] - $message" >> "$LOG_FILE"
    fi
}

# ============================================
# 风扇范围检测功能
# ============================================

# 检测风扇速度范围
detect_fan_range() {
    echo -e "${YELLOW}${MSG["detect_start"]}${NC}"
    echo -e "${YELLOW}${MSG["detect_warning"]}${NC}"
    echo ""
    
    # 检查是否已有缓存
    if [ -f "$RANGE_CACHE_FILE" ]; then
        source "$RANGE_CACHE_FILE"
        if [ -n "$FAN_MIN" ] && [ -n "$FAN_MAX" ]; then
            echo -e "${GREEN}${MSG["detect_already_done"]}${FAN_MIN}-${FAN_MAX}${NC}"
            echo "${MSG["detect_use_cache"]}"
            DETECTED_MIN=$FAN_MIN
            DETECTED_MAX=$FAN_MAX
            MIN_SPEED=$FAN_MIN
            MAX_SPEED=$FAN_MAX
            return 0
        fi
    fi
    
    # 检测硬件
    detect_hardware
    
    if [ -z "$FAN_DEVICE" ]; then
        echo -e "${RED}${MSG["no_fan_device"]}${NC}"
        return 1
    fi
    
    # 安全警告与确认
    local current_temp=$(get_max_temperature)
    if [ $current_temp -gt 60 ]; then
        echo -e "${RED}Warning: Current temperature is ${current_temp}°C.${NC}"
        echo -e "${RED}Stopping the fan for testing may cause overheating.${NC}"
        if [ "$LANG" = "cn" ]; then
            read -p "是否继续？(y/N): " confirm
        else
            read -p "Do you want to continue? (y/N): " confirm
        fi
        if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
            echo "${MSG["detect_cancelled"]}"
            FAN_MIN=0
            FAN_MAX=255
            DETECTED_MIN=0
            DETECTED_MAX=255
            return 1
        fi
    fi
    
    local detected_max=255
    local detected_min=0
    
    # 测试最大值255
    echo "${MSG["detect_testing_max"]}"
    if set_fan_speed 255; then
        sleep 1
        local detected=$(get_fan_status)
        echo "${MSG["detect_reported"]}$detected"
        
        if [ "$detected" = "255" ]; then
            detected_max=255
            echo -e "${GREEN}${MSG["detect_standard_range"]}${NC}"
        elif [ "$detected" -lt 10 ] 2>/dev/null; then
            detected_max=$detected
            echo -e "${GREEN}${MSG["detect_limited_range"]}${detected_max})${NC}"
        else
            detected_max=$detected
            echo -e "${YELLOW}${MSG["detect_unique_range"]}${detected_max}.${NC}"
        fi
    else
        # 测试小范围
        echo "${MSG["detect_testing_small"]}"
        for i in 10 5 4 3 2 1; do
            if set_fan_speed $i; then
                sleep 1
                local detected=$(get_fan_status)
                if [ "$detected" -le $i ] 2>/dev/null; then
                    detected_max=$detected
                    echo -e "${GREEN}${MSG["detect_max_level"]}${detected_max}${NC}"
                    break
                fi
            fi
        done
    fi
    
    # 测试最小值0
    echo "${MSG["detect_testing_min"]}"
    set_fan_speed 0
    sleep 2
    detected_min=$(get_fan_status)
    echo -e "${GREEN}${MSG["detect_min_level"]}${detected_min}${NC}"
    
    # 设置安全速度
    local safe_speed=0
    if [ "$detected_max" -gt "$detected_min" ] 2>/dev/null; then
        safe_speed=$(( (detected_max - detected_min) / 4 + detected_min ))
    fi
    set_fan_speed $safe_speed
    echo "${MSG["detect_set_safe"]}$safe_speed"
    
    # 保存结果
    FAN_MIN=$detected_min
    FAN_MAX=$detected_max
    DETECTED_MIN=$detected_min
    DETECTED_MAX=$detected_max
    MIN_SPEED=$detected_min
    MAX_SPEED=$detected_max
    
    # 写入缓存文件
    echo "FAN_MIN=$detected_min" > "$RANGE_CACHE_FILE"
    echo "FAN_MAX=$detected_max" >> "$RANGE_CACHE_FILE"
    echo "FAN_SAFE=$safe_speed" >> "$RANGE_CACHE_FILE"
    
    echo -e "${GREEN}${MSG["detect_complete"]}${detected_min}-${detected_max}${NC}"
    return 0
}

# ============================================
# 安装功能
# ============================================

# 检查root权限
check_root() {
    if [ "$EUID" -ne 0 ]; then
        show_msg "root_required"
        exit 1
    fi
}

# 检查操作系统
check_os() {
    if [ ! -f "/etc/debian_version" ] && [ ! -f "/etc/armbian-release" ]; then
        show_msg "unsupported_os"
        exit 1
    fi
}

# 安装依赖
install_dependencies() {
    echo "${MSG["installing_deps"]}"
    apt-get update > /dev/null 2>&1
    apt-get install -y curl wget bc lm-sensors > /dev/null 2>&1
}

# 创建配置文件
create_config() {
    echo "${MSG["creating_files"]}"
    
    # 先检测风扇范围
    detect_fan_range
    
    cat > "$CONFIG_FILE" << EOF
# ============================================
# Fan Control Daemon Configuration
# ============================================

# Temperature thresholds (Celsius)
HIGH_TEMP=$HIGH_TEMP      # High temperature threshold, fan runs at max speed
LOW_TEMP=$LOW_TEMP       # Low temperature threshold, fan runs at min speed

# Fan speed range (0-255)
MIN_SPEED=$MIN_SPEED      # Minimum fan speed (detected: $DETECTED_MIN)
MAX_SPEED=$MAX_SPEED     # Maximum fan speed (detected: $DETECTED_MAX)

# Check interval (seconds)
CHECK_INTERVAL=$CHECK_INTERVAL

# Logging settings
ENABLE_LOGGING=$ENABLE_LOGGING          # 1=Enable logging, 0=Disable logging
LOG_LEVEL="INFO"          # Log level: DEBUG, INFO, WARNING, ERROR

# Control mode
AUTO_CONTROL=$AUTO_CONTROL            # 1=Automatic control, 0=Manual control
MANUAL_SPEED=$MANUAL_SPEED          # Manual speed when AUTO_CONTROL=0

# Display settings
ENABLE_COLOR=1            # Enable colored output
SHOW_BARS=1               # Show progress bars
SHOW_ALL_SENSORS=1        # Show all temperature sensors

# Detected fan range (do not edit manually)
DETECTED_MIN=$DETECTED_MIN
DETECTED_MAX=$DETECTED_MAX

EOF
    show_msg "config_created"
}

# 创建服务文件
create_service() {
    cat > "$SERVICE_FILE" << EOF
[Unit]
Description=Fan Control Daemon for ARM SoC
After=syslog.target network.target multi-user.target
Wants=network.target

[Service]
Type=forking
ExecStart=$INSTALL_DIR/$SCRIPT_NAME start
ExecStop=$INSTALL_DIR/$SCRIPT_NAME stop
ExecReload=$INSTALL_DIR/$SCRIPT_NAME restart
Restart=always
RestartSec=10
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF
    show_msg "service_created"
}

# 设置权限
set_permissions() {
    echo "${MSG["setting_perms"]}"
    chmod 755 "$INSTALL_DIR/$SCRIPT_NAME"
    chmod 644 "$CONFIG_FILE"
    chmod 644 "$SERVICE_FILE"
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"
}

# 启用服务
enable_service() {
    echo "${MSG["reloading_systemd"]}"
    systemctl daemon-reload > /dev/null 2>&1
    
    echo "${MSG["enabling_service"]}"
    systemctl enable $SCRIPT_NAME > /dev/null 2>&1
    
    echo "${MSG["starting_service"]}"
    systemctl start $SCRIPT_NAME > /dev/null 2>&1
}

# 安装主函数
install_fan_control() {
    show_title
    echo "${MSG["install_title"]}"
    echo ""
    
    # 选择语言
    select_language
    
    # 检查权限和系统
    echo "${MSG["checking_root"]}"
    check_root
    echo "${MSG["detecting_os"]}"
    check_os
    
    # 检查是否已安装
    if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ] || [ -f "$CONFIG_FILE" ] || [ -f "$SERVICE_FILE" ]; then
        show_msg "existing_install"
        if [ "$LANG" = "cn" ]; then
            read -p "${MSG["overwrite_prompt"]}" overwrite
        else
            read -p "${MSG["overwrite_prompt"]}" overwrite
        fi
        
        if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
            show_msg "install_aborted"
            exit 0
        fi
        
        # 停止服务
        if systemctl is-active --quiet $SCRIPT_NAME; then
            systemctl stop $SCRIPT_NAME
        fi
    fi
    
    # 安装依赖
    install_dependencies
    
    # 创建目录
    mkdir -p "$LOG_DIR"
    
    # 复制自身到安装目录
    cp "$0" "$INSTALL_DIR/$SCRIPT_NAME"
    
    # 创建配置和服务文件
    create_config
    create_service
    set_permissions
    enable_service
    
    # 完成
    show_msg "installation_complete"
    echo ""
    
    if [ "$LANG" = "cn" ]; then
        echo "✅ 安装完成！"
        echo ""
        echo "📁 文件位置:"
        echo "  主脚本: $INSTALL_DIR/$SCRIPT_NAME"
        echo "  配置: $CONFIG_FILE"
        echo "  服务: $SERVICE_FILE"
        echo "  日志: $LOG_FILE"
        echo "  范围缓存: $RANGE_CACHE_FILE"
        echo ""
        echo "🎯 检测到的风扇范围: ${DETECTED_MIN}-${DETECTED_MAX}"
        echo ""
        echo "🚀 使用方法:"
        echo "  fan-control status    # 查看状态"
        echo "  fan-control start     # 启动"
        echo "  fan-control stop      # 停止"
        echo "  fan-control config    # 编辑配置"
        echo "  fan-control log       # 查看日志"
        echo ""
        echo "🔧 管理服务:"
        echo "  systemctl status fan-control"
        echo "  systemctl restart fan-control"
        echo ""
        echo "❓ 帮助信息:"
        echo "  fan-control help"
    else
        echo "✅ Installation complete!"
        echo ""
        echo "📁 File locations:"
        echo "  Main script: $INSTALL_DIR/$SCRIPT_NAME"
        echo "  Config: $CONFIG_FILE"
        echo "  Service: $SERVICE_FILE"
        echo "  Log: $LOG_FILE"
        echo "  Range cache: $RANGE_CACHE_FILE"
        echo ""
        echo "🎯 Detected fan range: ${DETECTED_MIN}-${DETECTED_MAX}"
        echo ""
        echo "🚀 Usage:"
        echo "  fan-control status    # Show status"
        echo "  fan-control start     # Start"
        echo "  fan-control stop      # Stop"
        echo "  fan-control config    # Edit config"
        echo "  fan-control log       # View logs"
        echo ""
        echo "🔧 Service management:"
        echo "  systemctl status fan-control"
        echo "  systemctl restart fan-control"
        echo ""
        echo "❓ Help:"
        echo "  fan-control help"
    fi
}

# 卸载功能
uninstall_fan_control() {
    show_title
    echo "${MSG["uninstall_title"]}"
    echo ""
    
    # 选择语言
    select_language
    
    # 确认
    if [ "$LANG" = "cn" ]; then
        read -p "${MSG["uninstall_confirm"]}" confirm
    else
        read -p "${MSG["uninstall_confirm"]}" confirm
    fi
    
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        if [ "$LANG" = "cn" ]; then
            echo "卸载已取消"
        else
            echo "Uninstall cancelled"
        fi
        exit 0
    fi
    
    echo "${MSG["uninstalling"]}"
    
    # 停止服务
    if systemctl is-active --quiet $SCRIPT_NAME; then
        systemctl stop $SCRIPT_NAME
        show_msg "service_stopped_uninstall"
    fi
    
    # 禁用服务
    if systemctl is-enabled --quiet $SCRIPT_NAME 2>/dev/null; then
        systemctl disable $SCRIPT_NAME
    fi
    
    # 移除服务文件
    rm -f "$SERVICE_FILE"
    systemctl daemon-reload > /dev/null 2>&1
    
    # 移除主脚本
    rm -f "$INSTALL_DIR/$SCRIPT_NAME"
    
    # 询问是否保留配置文件
    if [ -f "$CONFIG_FILE" ]; then
        if [ "$LANG" = "cn" ]; then
            read -p "${MSG["keep_config"]}" keep_config
        else
            read -p "${MSG["keep_config"]}" keep_config
        fi
        
        if [ "$keep_config" != "y" ] && [ "$keep_config" != "Y" ]; then
            rm -f "$CONFIG_FILE"
        fi
    fi
    
    # 移除日志和缓存文件
    rm -f "$LOG_FILE"
    rm -f "$PID_FILE"
    rm -f "$RANGE_CACHE_FILE"
    
    show_msg "uninstall_complete"
    
    if [ "$LANG" = "cn" ]; then
        echo "✅ 卸载完成！"
        echo "已移除的文件:"
        [ -f "$SERVICE_FILE" ] || echo "  • $SERVICE_FILE"
        [ -f "$INSTALL_DIR/$SCRIPT_NAME" ] || echo "  • $INSTALL_DIR/$SCRIPT_NAME"
        [ -f "$CONFIG_FILE" ] || echo "  • $CONFIG_FILE"
        [ -f "$LOG_FILE" ] || echo "  • $LOG_FILE"
        [ -f "$PID_FILE" ] || echo "  • $PID_FILE"
        [ -f "$RANGE_CACHE_FILE" ] || echo "  • $RANGE_CACHE_FILE"
    else
        echo "✅ Uninstall complete!"
        echo "Removed files:"
        [ -f "$SERVICE_FILE" ] || echo "  • $SERVICE_FILE"
        [ -f "$INSTALL_DIR/$SCRIPT_NAME" ] || echo "  • $INSTALL_DIR/$SCRIPT_NAME"
        [ -f "$CONFIG_FILE" ] || echo "  • $CONFIG_FILE"
        [ -f "$LOG_FILE" ] || echo "  • $LOG_FILE"
        [ -f "$PID_FILE" ] || echo "  • $PID_FILE"
        [ -f "$RANGE_CACHE_FILE" ] || echo "  • $RANGE_CACHE_FILE"
    fi
}

# ============================================
# 配置菜单功能
# ============================================

# 配置项定义
declare -A CONFIG_ITEMS
declare -A CONFIG_DESCRIPTIONS
declare -A CONFIG_RECOMMENDATIONS

# 初始化配置项
init_config_items() {
    # 配置项名称 -> 变量名映射
    CONFIG_ITEMS[1]="LANGUAGE"
    CONFIG_ITEMS[2]="HIGH_TEMP"
    CONFIG_ITEMS[3]="LOW_TEMP"
    CONFIG_ITEMS[4]="MIN_SPEED"
    CONFIG_ITEMS[5]="MAX_SPEED"
    CONFIG_ITEMS[6]="CHECK_INTERVAL"
    CONFIG_ITEMS[7]="AUTO_CONTROL"
    CONFIG_ITEMS[8]="MANUAL_SPEED"
    CONFIG_ITEMS[9]="ENABLE_LOGGING"
    
    # 配置项描述
    if [ "$LANG" = "cn" ]; then
        CONFIG_DESCRIPTIONS["LANGUAGE"]="显示语言（en=英文，cn=中文）：界面显示语言"
        CONFIG_DESCRIPTIONS["HIGH_TEMP"]="高温阈值（℃）：达到此温度时风扇全速运行"
        CONFIG_DESCRIPTIONS["LOW_TEMP"]="低温阈值（℃）：低于此温度时风扇最低速运行"
        CONFIG_DESCRIPTIONS["MIN_SPEED"]="最低风扇速度：风扇最低转速（检测范围: $DETECTED_MIN-$DETECTED_MAX）"
        CONFIG_DESCRIPTIONS["MAX_SPEED"]="最高风扇速度：风扇最高转速（检测范围: $DETECTED_MIN-$DETECTED_MAX）"
        CONFIG_DESCRIPTIONS["CHECK_INTERVAL"]="检查间隔（秒）：温度检查频率"
        CONFIG_DESCRIPTIONS["AUTO_CONTROL"]="自动控制（1=自动，0=手动）：是否自动调节风扇"
        CONFIG_DESCRIPTIONS["MANUAL_SPEED"]="手动速度：手动模式下的固定速度（检测范围: $DETECTED_MIN-$DETECTED_MAX）"
        CONFIG_DESCRIPTIONS["ENABLE_LOGGING"]="启用日志（1=启用，0=禁用）：是否记录日志"
        
        # 推荐值
        CONFIG_RECOMMENDATIONS["LANGUAGE"]="en/cn（根据偏好选择）"
        CONFIG_RECOMMENDATIONS["HIGH_TEMP"]="65-80（根据硬件调整）"
        CONFIG_RECOMMENDATIONS["LOW_TEMP"]="40-55（通常比室温高10-20℃）"
        CONFIG_RECOMMENDATIONS["MIN_SPEED"]="$DETECTED_MIN（检测到的最小值）"
        CONFIG_RECOMMENDATIONS["MAX_SPEED"]="$DETECTED_MAX（检测到的最大值）"
        CONFIG_RECOMMENDATIONS["CHECK_INTERVAL"]="3-10（太短增加CPU负担）"
        CONFIG_RECOMMENDATIONS["AUTO_CONTROL"]="1（推荐自动控制）"
        CONFIG_RECOMMENDATIONS["MANUAL_SPEED"]="$(( (DETECTED_MAX - DETECTED_MIN) / 2 + DETECTED_MIN ))（中等速度）"
        CONFIG_RECOMMENDATIONS["ENABLE_LOGGING"]="1（推荐启用）"
    else
        CONFIG_DESCRIPTIONS["LANGUAGE"]="Display language (en=English, cn=Chinese): Interface display language"
        CONFIG_DESCRIPTIONS["HIGH_TEMP"]="High temperature threshold (°C): Fan runs at max speed at this temperature"
        CONFIG_DESCRIPTIONS["LOW_TEMP"]="Low temperature threshold (°C): Fan runs at min speed below this temperature"
        CONFIG_DESCRIPTIONS["MIN_SPEED"]="Minimum fan speed: Minimum fan rotation speed (detected range: $DETECTED_MIN-$DETECTED_MAX)"
        CONFIG_DESCRIPTIONS["MAX_SPEED"]="Maximum fan speed: Maximum fan rotation speed (detected range: $DETECTED_MIN-$DETECTED_MAX)"
        CONFIG_DESCRIPTIONS["CHECK_INTERVAL"]="Check interval (seconds): How often to check temperature"
        CONFIG_DESCRIPTIONS["AUTO_CONTROL"]="Auto control (1=auto, 0=manual): Whether to automatically adjust fan"
        CONFIG_DESCRIPTIONS["MANUAL_SPEED"]="Manual speed: Fixed speed in manual mode (detected range: $DETECTED_MIN-$DETECTED_MAX)"
        CONFIG_DESCRIPTIONS["ENABLE_LOGGING"]="Enable logging (1=enabled, 0=disabled): Whether to log events"
        
        # 推荐值
        CONFIG_RECOMMENDATIONS["LANGUAGE"]="en/cn (choose based on preference)"
        CONFIG_RECOMMENDATIONS["HIGH_TEMP"]="65-80 (adjust based on hardware)"
        CONFIG_RECOMMENDATIONS["LOW_TEMP"]="40-55 (usually 10-20°C above room temp)"
        CONFIG_RECOMMENDATIONS["MIN_SPEED"]="$DETECTED_MIN (detected minimum)"
        CONFIG_RECOMMENDATIONS["MAX_SPEED"]="$DETECTED_MAX (detected maximum)"
        CONFIG_RECOMMENDATIONS["CHECK_INTERVAL"]="3-10 (too short increases CPU load)"
        CONFIG_RECOMMENDATIONS["AUTO_CONTROL"]="1 (recommended auto control)"
        CONFIG_RECOMMENDATIONS["MANUAL_SPEED"]="$(( (DETECTED_MAX - DETECTED_MIN) / 2 + DETECTED_MIN )) (medium speed)"
        CONFIG_RECOMMENDATIONS["ENABLE_LOGGING"]="1 (recommended enabled)"
    fi
}

# 计算字符串的显示宽度（考虑中文字符）
get_display_width() {
    local str="$1"
    local width=0
    local i
    
    # 遍历字符串的每个字符
    for ((i = 0; i < ${#str}; i++)); do
        local char="${str:$i:1}"
        # 判断是否为中文字符（Unicode编码大于127）
        if [[ $(printf "%d" "'$char") -gt 127 ]]; then
            # 中文字符占2个宽度
            width=$((width + 2))
        else
            # 英文字符占1个宽度
            width=$((width + 1))
        fi
    done
    
    echo $width
}

# 截断字符串到指定显示宽度
truncate_to_width() {
    local str="$1"
    local max_width="$2"
    local truncated=""
    local current_width=0
    local i
    
    # 如果最大宽度小于等于0，直接返回空字符串
    if [ $max_width -le 0 ]; then
        echo ""
        return
    fi
    
    # 遍历字符串的每个字符
    for ((i = 0; i < ${#str}; i++)); do
        local char="${str:$i:1}"
        local char_width=1
        
        # 判断是否为中文字符
        if [[ $(printf "%d" "'$char") -gt 127 ]]; then
            char_width=2
        fi
        
        # 如果添加这个字符会超出最大宽度
        if [ $((current_width + char_width)) -gt $max_width ]; then
            # 如果还有空间添加"..."
            if [ $((current_width + 3)) -le $max_width ]; then
                truncated="${truncated}..."
                current_width=$((current_width + 3))
            fi
            break
        fi
        
        # 添加字符到结果
        truncated="${truncated}${char}"
        current_width=$((current_width + char_width))
    done
    
    echo "$truncated"
}

# 显示表格（处理中文对齐问题）
display_table() {
    local headers=("${!1}")  # 表头数组
    local data_rows=("${!2}")  # 数据行数组
    local max_width=80
    local min_col_width=3
    
    # 计算每列的最大显示宽度
    local col_count=${#headers[@]}
    declare -a col_widths
    
    # 初始化每列宽度为表头宽度
    for ((i=0; i<col_count; i++)); do
        col_widths[$i]=$(get_display_width "${headers[$i]}")
    done
    
    # 遍历数据行，更新最大宽度
    for row in "${data_rows[@]}"; do
        # 将行数据分割为列
        IFS='|' read -ra cols <<< "$row"
        for ((i=0; i<${#cols[@]}; i++)); do
            if [ $i -lt $col_count ]; then
                local width=$(get_display_width "${cols[$i]}")
                if [ $width -gt ${col_widths[$i]} ]; then
                    col_widths[$i]=$width
                fi
                if [ ${col_widths[$i]} -lt $min_col_width ]; then
                    col_widths[$i]=$min_col_width
                fi
            fi
        done
    done
    
    # 计算总宽度
    local total_width=0
    for width in "${col_widths[@]}"; do
        total_width=$((total_width + width + 1))  # +1 用于列间空格
    done
    
    # 如果总宽度超过最大宽度，调整最后一列
    if [ $total_width -gt $max_width ] && [ $col_count -gt 0 ]; then
        local excess=$((total_width - max_width))
        col_widths[$((col_count-1))]=$((col_widths[$((col_count-1))] - excess))
        if [ ${col_widths[$((col_count-1))]} -lt $min_col_width ]; then
            col_widths[$((col_count-1))]=$min_col_width
        fi
    fi
    
    # 打印表头
    for ((i=0; i<col_count; i++)); do
        printf "%-${col_widths[$i]}s" "${headers[$i]}"
        printf " "
    done
    printf "\n"
    
    # 打印表头分隔线
    for ((i=0; i<col_count; i++)); do
        printf -- "-%.0s" $(seq 1 ${col_widths[$i]})
        printf " "
    done
    printf "\n"
    
    # 打印数据行
    for row in "${data_rows[@]}"; do
        IFS='|' read -ra cols <<< "$row"
        for ((i=0; i<col_count; i++)); do
            if [ $i -lt ${#cols[@]} ]; then
                local cell="${cols[$i]}"
                local width=${col_widths[$i]}
                
                # 如果内容超过列宽，截断并添加"..."
                local display_width=$(get_display_width "$cell")
                if [ $display_width -gt $width ]; then
                    cell=$(truncate_to_width "$cell" $width)
                fi
                
                printf "%-${col_widths[$i]}s " "$cell"
            else
                printf "%-${col_widths[$i]}s " ""
            fi
        done
        printf "\n"
    done
}

# 重新设计 show_config_menu 函数
show_config_menu() {
    load_config
    init_config_items
    
    local choice=0
    local config_changed=0  # 跟踪配置是否被修改
    declare -A original_values  # 保存原始值
    
    # 保存原始值用于比较
    original_values["LANGUAGE"]="$LANG"
    original_values["HIGH_TEMP"]="$HIGH_TEMP"
    original_values["LOW_TEMP"]="$LOW_TEMP"
    original_values["MIN_SPEED"]="$MIN_SPEED"
    original_values["MAX_SPEED"]="$MAX_SPEED"
    original_values["CHECK_INTERVAL"]="$CHECK_INTERVAL"
    original_values["AUTO_CONTROL"]="$AUTO_CONTROL"
    original_values["MANUAL_SPEED"]="$MANUAL_SPEED"
    original_values["ENABLE_LOGGING"]="$ENABLE_LOGGING"
    
    while true; do
        clear
        echo -e "${CYAN}${SEPARATOR}${NC}"
        echo -e "${CYAN}        ${MSG["config_menu"]}        ${NC}"
        echo -e "${CYAN}${SEPARATOR}${NC}"
        echo ""
        
        # 显示当前配置
        echo -e "${WHITE}Current Configuration:${NC}"
        echo -e "${WHITE}=====================${NC}"
        echo ""
        
        # 准备表头和数据
        local headers=()
        local data_rows=()
        
        if [ "$LANG" = "cn" ]; then
            headers=("ID" "配置项" "当前值" "说明")
        else
            headers=("ID" "Config Item" "Current Value" "Description")
        fi
        
        # 构建数据行
        for i in {1..9}; do
            local item="${CONFIG_ITEMS[$i]}"
            local value=""
            local item_name=""
            local description=""
            
            # 获取当前值
            case $item in
                "LANGUAGE") value="$LANG" ;;
                "HIGH_TEMP") value="$HIGH_TEMP" ;;
                "LOW_TEMP") value="$LOW_TEMP" ;;
                "MIN_SPEED") value="$MIN_SPEED" ;;
                "MAX_SPEED") value="$MAX_SPEED" ;;
                "CHECK_INTERVAL") value="$CHECK_INTERVAL" ;;
                "AUTO_CONTROL") value="$AUTO_CONTROL" ;;
                "MANUAL_SPEED") value="$MANUAL_SPEED" ;;
                "ENABLE_LOGGING") value="$ENABLE_LOGGING" ;;
            esac
            
            # 获取配置项显示名称
            if [ "$LANG" = "cn" ]; then
                case $item in
                    "LANGUAGE") item_name="语言设置" ;;
                    "HIGH_TEMP") item_name="高温阈值" ;;
                    "LOW_TEMP") item_name="低温阈值" ;;
                    "MIN_SPEED") item_name="最低速度" ;;
                    "MAX_SPEED") item_name="最高速度" ;;
                    "CHECK_INTERVAL") item_name="检查间隔" ;;
                    "AUTO_CONTROL") item_name="自动控制" ;;
                    "MANUAL_SPEED") item_name="手动速度" ;;
                    "ENABLE_LOGGING") item_name="启用日志" ;;
                esac
            else
                case $item in
                    "LANGUAGE") item_name="Language" ;;
                    *) item_name="$item" ;;
                esac
            fi
            
            # 获取描述
            description="${CONFIG_DESCRIPTIONS[$item]}"
            
            # 构建数据行（使用 | 作为列分隔符）
            data_rows+=("$i|$item_name|$value|$description")
        done
        
        # 显示表格
        display_table headers[@] data_rows[@]
        
        echo ""
        echo "0. ${MSG["config_exit"]}"
        echo ""
        
        # 显示配置修改提示
        if [ $config_changed -eq 1 ]; then
            if [ "$LANG" = "cn" ]; then
                echo -e "${YELLOW}⚠ 配置已修改，请选择0保存并退出${NC}"
            else
                echo -e "${YELLOW}⚠ Configuration modified, select 0 to save and exit${NC}"
            fi
        fi
        
        if [ "$LANG" = "cn" ]; then
            read -p "请选择配置项 (0-9): " choice
        else
            read -p "Select config item (0-9): " choice
        fi
        
        case $choice in
            1|2|3|4|5|6|7|8|9)
                if config_item "${CONFIG_ITEMS[$choice]}"; then
                    config_changed=1
                    # 如果修改了语言，需要重新初始化配置项描述
                    if [ "${CONFIG_ITEMS[$choice]}" = "LANGUAGE" ]; then
                        init_config_items
                        # 重新加载消息系统，确保后续提示使用新语言
                        set_language
                    fi
                fi
                ;;
            0)
                # 退出配置菜单前，检查配置是否被修改
                # 需要比较当前值和原始值
                local any_changed=0
                
                # 检查语言是否改变
                if [ "$LANG" != "${original_values["LANGUAGE"]}" ]; then
                    any_changed=1
                fi
                
                # 检查其他配置项是否改变
                for item in "${CONFIG_ITEMS[@]}"; do
                    if [ "$item" != "LANGUAGE" ]; then
                        local current_value=""
                        local original_value="${original_values[$item]}"
                        
                        case $item in
                            "HIGH_TEMP") current_value="$HIGH_TEMP" ;;
                            "LOW_TEMP") current_value="$LOW_TEMP" ;;
                            "MIN_SPEED") current_value="$MIN_SPEED" ;;
                            "MAX_SPEED") current_value="$MAX_SPEED" ;;
                            "CHECK_INTERVAL") current_value="$CHECK_INTERVAL" ;;
                            "AUTO_CONTROL") current_value="$AUTO_CONTROL" ;;
                            "MANUAL_SPEED") current_value="$MANUAL_SPEED" ;;
                            "ENABLE_LOGGING") current_value="$ENABLE_LOGGING" ;;
                        esac
                        
                        if [ "$current_value" != "$original_value" ]; then
                            any_changed=1
                            break
                        fi
                    fi
                done
                
                if [ $any_changed -eq 1 ] || [ $config_changed -eq 1 ]; then
                    save_configuration
                else
                    # 没有修改，直接退出
                    if [ "$LANG" = "cn" ]; then
                        echo "配置未修改，直接退出"
                    else
                        echo "No changes made, exiting"
                    fi
                    sleep 2
                fi
                break
                ;;
            *)
                if [ "$LANG" = "cn" ]; then
                    echo "无效选择"
                else
                    echo "Invalid selection"
                fi
                sleep 2
                ;;
        esac
    done
}

# 配置单个项
config_item() {
    local item="$1"
    local current_value=""
    local new_value=""
    local changed=0  # 返回是否修改了配置
    
    # 获取当前值
    case $item in
        "LANGUAGE") current_value="$LANG" ;;
        "HIGH_TEMP") current_value="$HIGH_TEMP" ;;
        "LOW_TEMP") current_value="$LOW_TEMP" ;;
        "MIN_SPEED") current_value="$MIN_SPEED" ;;
        "MAX_SPEED") current_value="$MAX_SPEED" ;;
        "CHECK_INTERVAL") current_value="$CHECK_INTERVAL" ;;
        "AUTO_CONTROL") current_value="$AUTO_CONTROL" ;;
        "MANUAL_SPEED") current_value="$MANUAL_SPEED" ;;
        "ENABLE_LOGGING") current_value="$ENABLE_LOGGING" ;;
    esac
    
    clear
    echo -e "${CYAN}${SEPARATOR}${NC}"
    echo -e "${CYAN}         Configure: $item         ${NC}"
    echo -e "${CYAN}${SEPARATOR}${NC}"
    echo ""
    
    # 显示详细信息
    echo -e "${WHITE}${MSG["description"]}:${NC}"
    echo "  ${CONFIG_DESCRIPTIONS[$item]}"
    echo ""
    echo -e "${WHITE}${MSG["recommended"]}:${NC}"
    echo "  ${CONFIG_RECOMMENDATIONS[$item]}"
    echo ""
    echo -e "${WHITE}${MSG["current_value"]}:${NC} $current_value"
    echo ""
    
    # 输入新值
    echo -e "${WHITE}${MSG["enter_new_value"]}${NC}"
    read new_value
    
    # 如果用户输入了新值
    if [ -n "$new_value" ]; then
        # 验证输入
        case $item in
            "LANGUAGE")
                # 规范化输入
                local normalized_new_value="$new_value"
                if [ "$new_value" = "zh" ] || [ "$new_value" = "ZH" ]; then
                    normalized_new_value="cn"
                elif [ "$new_value" = "EN" ]; then
                    normalized_new_value="en"
                fi
                
                if [ "$normalized_new_value" = "en" ] || [ "$normalized_new_value" = "cn" ]; then
                    if [ "$normalized_new_value" != "$current_value" ]; then
                        # 记录原始语言用于比较
                        local original_lang="$LANG"
                        
                        # 设置新语言
                        LANG="$normalized_new_value"
                        set_language
                        
                        # 清除命令行设置标记，因为用户通过菜单修改了语言
                        LANG_SET_BY_CLI=0
                        
                        changed=1
                        if [ "$LANG" = "cn" ]; then
                            echo "✅ 语言已更新为: $normalized_new_value"
                            echo "注意：界面语言已更新"
                        else
                            echo "✅ Language updated to: $normalized_new_value"
                            echo "Note: Interface language has been updated"
                        fi
                    else
                        if [ "$LANG" = "cn" ]; then
                            echo "值未改变"
                        else
                            echo "Value unchanged"
                        fi
                    fi
                else
                    show_msg "invalid_input"
                fi
                ;;
            "HIGH_TEMP"|"LOW_TEMP")
                if [[ "$new_value" =~ ^[0-9]+$ ]] && [ $new_value -ge 0 ] && [ $new_value -le 120 ]; then
                    if [ "$new_value" != "$current_value" ]; then
                        eval "$item=\"$new_value\""
                        changed=1
                        if [ "$LANG" = "cn" ]; then
                            echo "✅ $item 已更新为: $new_value"
                        else
                            echo "✅ $item updated to: $new_value"
                        fi
                    else
                        if [ "$LANG" = "cn" ]; then
                            echo "值未改变"
                        else
                            echo "Value unchanged"
                        fi
                    fi
                else
                    show_msg "invalid_input"
                fi
                ;;
            "MIN_SPEED"|"MAX_SPEED"|"MANUAL_SPEED")
                # 检查是否在检测到的范围内
                if [[ "$new_value" =~ ^[0-9]+$ ]] && [ $new_value -ge $DETECTED_MIN ] && [ $new_value -le $DETECTED_MAX ]; then
                    if [ "$new_value" != "$current_value" ]; then
                        eval "$item=\"$new_value\""
                        changed=1
                        if [ "$LANG" = "cn" ]; then
                            echo "✅ $item 已更新为: $new_value"
                        else
                            echo "✅ $item updated to: $new_value"
                        fi
                    else
                        if [ "$LANG" = "cn" ]; then
                            echo "值未改变"
                        else
                            echo "Value unchanged"
                        fi
                    fi
                else
                    if [ "$LANG" = "cn" ]; then
                        echo "❌ 无效输入，必须在 $DETECTED_MIN 到 $DETECTED_MAX 之间"
                    else
                        echo "❌ Invalid input, must be between $DETECTED_MIN and $DETECTED_MAX"
                    fi
                    show_msg "invalid_input"
                fi
                ;;
            "CHECK_INTERVAL")
                if [[ "$new_value" =~ ^[0-9]+$ ]] && [ $new_value -ge 1 ] && [ $new_value -le 60 ]; then
                    if [ "$new_value" != "$current_value" ]; then
                        eval "$item=\"$new_value\""
                        changed=1
                        if [ "$LANG" = "cn" ]; then
                            echo "✅ $item 已更新为: $new_value"
                        else
                            echo "✅ $item updated to: $new_value"
                        fi
                    else
                        if [ "$LANG" = "cn" ]; then
                            echo "值未改变"
                        else
                            echo "Value unchanged"
                        fi
                    fi
                else
                    show_msg "invalid_input"
                fi
                ;;
            "AUTO_CONTROL"|"ENABLE_LOGGING")
                if [[ "$new_value" =~ ^[01]$ ]]; then
                    if [ "$new_value" != "$current_value" ]; then
                        eval "$item=\"$new_value\""
                        changed=1
                        if [ "$LANG" = "cn" ]; then
                            echo "✅ $item 已更新为: $new_value"
                        else
                            echo "✅ $item updated to: $new_value"
                        fi
                    else
                        if [ "$LANG" = "cn" ]; then
                            echo "值未改变"
                        else
                            echo "Value unchanged"
                        fi
                    fi
                else
                    show_msg "invalid_input"
                fi
                ;;
        esac
    else
        if [ "$LANG" = "cn" ]; then
            echo "保持当前值: $current_value"
        else
            echo "Keeping current value: $current_value"
        fi
    fi
    
    sleep 2
    return $changed  # 返回修改状态
}

# 保存配置
save_configuration() {
    echo ""
    echo -e "${CYAN}${SEPARATOR}${NC}"
    
    # 询问是否保存配置
    if [ "$LANG" = "cn" ]; then
        read -p "是否保存配置更改？(y/n): " save
    else
        read -p "Save configuration changes? (y/n): " save
    fi
    
    if [ "$save" = "y" ] || [ "$save" = "Y" ]; then
        # 备份原配置文件
        if [ -f "$CONFIG_FILE" ]; then
            cp "$CONFIG_FILE" "${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        
        # 获取当前语言（可能是通过config菜单修改的）
        local current_lang="$LANG"
        
        # 创建新配置文件，包含语言设置
        cat > "$CONFIG_FILE" << EOF
# ============================================
# Fan Control Daemon Configuration
# ============================================

# Language setting (en=English, cn=Chinese)
LANGUAGE="$current_lang"

# Temperature thresholds (Celsius)
HIGH_TEMP=$HIGH_TEMP      # High temperature threshold, fan runs at max speed
LOW_TEMP=$LOW_TEMP       # Low temperature threshold, fan runs at min speed

# Fan speed range (0-255)
MIN_SPEED=$MIN_SPEED      # Minimum fan speed (detected: $DETECTED_MIN)
MAX_SPEED=$MAX_SPEED     # Maximum fan speed (detected: $DETECTED_MAX)

# Check interval (seconds)
CHECK_INTERVAL=$CHECK_INTERVAL

# Logging settings
ENABLE_LOGGING=$ENABLE_LOGGING          # 1=Enable logging, 0=Disable logging
LOG_LEVEL="INFO"          # Log level: DEBUG, INFO, WARNING, ERROR

# Control mode
AUTO_CONTROL=$AUTO_CONTROL            # 1=Automatic control, 0=Manual control
MANUAL_SPEED=$MANUAL_SPEED          # Manual speed when AUTO_CONTROL=0

# Display settings
ENABLE_COLOR=1            # Enable colored output
SHOW_BARS=1               # Show progress bars
SHOW_ALL_SENSORS=1        # Show all temperature sensors

# Detected fan range (do not edit manually)
DETECTED_MIN=$DETECTED_MIN
DETECTED_MAX=$DETECTED_MAX

EOF
        
        show_msg "config_saved"
        echo ""
        show_msg "config_restart_hint"
    else
        if [ "$LANG" = "cn" ]; then
            echo "配置更改未保存"
        else
            echo "Configuration changes not saved"
        fi
    fi
    
    sleep 2
}

# ============================================
# 风扇控制功能
# ============================================

# 停止风扇（完全停止）
stop_fan_completely() {
    load_config
    detect_hardware
    
    # 检查温度是否过高
    local max_temp=$(get_max_temperature)
    if [ $max_temp -gt 70 ]; then
        echo -e "${RED}${MSG["temp_too_high"]}${NC}"
        echo -e "${YELLOW}${MSG["temp_warning_threshold"]}${NC}"
        echo "Current temperature: ${max_temp}°C"
        
        if [ "$LANG" = "cn" ]; then
            read -p "仍然要停止风扇吗？(y/n): " confirm
        else
            read -p "Still want to stop the fan? (y/n): " confirm
        fi
        
        if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
            echo "Operation cancelled"
            return 1
        fi
    else
        # 确认停止
        if [ "$LANG" = "cn" ]; then
            read -p "${MSG["confirm_fan_stop"]}" confirm
        else
            read -p "${MSG["confirm_fan_stop"]}" confirm
        fi
        
        if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
            echo "Operation cancelled"
            return 1
        fi
    fi
    
    # 停止守护进程
    if systemctl is-active --quiet $SCRIPT_NAME; then
        systemctl stop $SCRIPT_NAME
    fi
    
    # 设置风扇速度为最小值
    if set_fan_speed $DETECTED_MIN; then
        show_msg "fan_stopped"
        log_message "WARNING" "Fan manually stopped by user"
        
        if [ "$LANG" = "cn" ]; then
            echo "风扇已完全停止。温度监控将继续。"
            echo "使用 'fan-control start' 重新启动自动控制。"
        else
            echo "Fan completely stopped. Temperature monitoring continues."
            echo "Use 'fan-control start' to restart automatic control."
        fi
        return 0
    else
        echo "Failed to stop fan"
        return 1
    fi
}

# 启动风扇控制
start_fan_control() {
    # 先检查当前温度
    load_config
    detect_hardware
    local max_temp=$(get_max_temperature)
    
    # 如果温度过高，先设置适当的风扇速度
    if [ $max_temp -gt $HIGH_TEMP ]; then
        echo -e "${YELLOW}High temperature detected: ${max_temp}°C${NC}"
        echo "Setting fan to maximum speed first..."
        set_fan_speed $MAX_SPEED
        sleep 2
    fi
    
    # 启动守护进程
    if systemctl start $SCRIPT_NAME; then
        show_msg "fan_started"
        if [ "$LANG" = "cn" ]; then
            echo "风扇控制已启动，正在监控温度..."
        else
            echo "Fan control started, monitoring temperature..."
        fi
        return 0
    else
        echo "Failed to start fan control"
        return 1
    fi
}

# ============================================
# 状态显示功能
# ============================================

# 显示状态 - 使用固定长度分隔线
show_status() {
    load_config
    detect_hardware
    
    local max_temp=$(get_max_temperature)
    local fan_status=$(get_fan_status)
    local fan_percent=0
    
    # 计算百分比
    if [ "$fan_status" != "N/A" ] && [ "$fan_status" -ge 0 ] 2>/dev/null; then
        if [ $DETECTED_MAX -gt $DETECTED_MIN ]; then
            fan_percent=$(( (fan_status - DETECTED_MIN) * 100 / (DETECTED_MAX - DETECTED_MIN) ))
        fi
    fi
    
    # 检查服务状态
    local service_status=""
    if systemctl is-active --quiet $SCRIPT_NAME; then
        service_status="${GREEN}● RUNNING${NC}"
    else
        service_status="${RED}● STOPPED${NC}"
    fi
    
    # 使用固定长度的分隔线
    echo -e "${CYAN}${SEPARATOR}${NC}"
    echo -e "${CYAN}      FAN CONTROL DAEMON STATUS      ${NC}"
    echo -e "${CYAN}${SEPARATOR}${NC}"
    echo ""
    
    # 服务状态
    echo -e "${WHITE}Service Status:${NC} $service_status"
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        echo -e "${WHITE}PID:${NC} $pid"
    fi
    echo ""
    
    # 温度信息
    echo -e "${WHITE}Temperature Information:${NC}"
    echo -e "${WHITE}Current Max Temp:${NC} $max_temp°C"
    echo -e "${WHITE}Thresholds:${NC} ${LOW_TEMP}°C (Low) - ${HIGH_TEMP}°C (High)"
    echo ""
    
    # 温度传感器详情
    local temps=$(get_all_temperatures)
    if [ -n "$temps" ]; then
        echo -e "${WHITE}Thermal Sensors:${NC}"
        echo -e "$temps"
    fi
    
    # 风扇信息
    echo -e "${WHITE}Fan Control:${NC}"
    if [ -n "$FAN_DEVICE" ]; then
        echo -e "${WHITE}Device:${NC} $(basename $FAN_DEVICE)"
        echo -e "${WHITE}Detected Range:${NC} $DETECTED_MIN-$DETECTED_MAX"
        echo -e "${WHITE}Current Speed:${NC} $fan_status (${fan_percent}%)"
        echo -e "${WHITE}Control Mode:${NC} $(if [ $AUTO_CONTROL -eq 1 ]; then echo "AUTO"; else echo "MANUAL"; fi)"
        echo -e "${WHITE}Configured Range:${NC} ${MIN_SPEED}-${MAX_SPEED}"
        
        # 显示简单的速度条
        if [ "$fan_status" != "N/A" ] && [ $fan_percent -ge 0 ]; then
            echo -e "${WHITE}Speed Bar:${NC}"
            local bar_width=30
            local bar_pos=$((fan_percent * bar_width / 100))
            echo -n "["
            for ((i=0; i<bar_width; i++)); do
                if [ $i -lt $bar_pos ]; then
                    if [ $fan_percent -ge 80 ]; then
                        echo -ne "${RED}█${NC}"
                    elif [ $fan_percent -ge 50 ]; then
                        echo -ne "${YELLOW}█${NC}"
                    else
                        echo -ne "${GREEN}█${NC}"
                    fi
                else
                    echo -ne "${GRAY}░${NC}"
                fi
            done
            echo "]"
        fi
    else
        echo -e "${RED}No fan device detected${NC}"
    fi
    echo ""
    
    # 配置信息
    echo -e "${WHITE}Configuration:${NC}"
    echo -e "${WHITE}Config File:${NC} $CONFIG_FILE"
    echo -e "${WHITE}Log File:${NC} $LOG_FILE"
    echo -e "${WHITE}Check Interval:${NC} ${CHECK_INTERVAL}s"
    echo ""
    
    # 控制状态
    if [ $AUTO_CONTROL -eq 1 ]; then
        local expected_speed=$(calculate_fan_speed $max_temp)
        local expected_percent=0
        if [ $DETECTED_MAX -gt $DETECTED_MIN ]; then
            expected_percent=$(( (expected_speed - DETECTED_MIN) * 100 / (DETECTED_MAX - DETECTED_MIN) ))
        fi
        echo -e "${WHITE}Control Status:${NC} ${GREEN}AUTO${NC}"
        echo -e "${WHITE}Target Speed:${NC} $expected_speed (${expected_percent}%)"
        
        # 显示温度条
        echo -e "${WHITE}Temperature Bar:${NC}"
        local temp_bar_width=30
        local temp_pos=$(( (max_temp - LOW_TEMP) * temp_bar_width / (HIGH_TEMP - LOW_TEMP) ))
        if [ $temp_pos -lt 0 ]; then
            temp_pos=0
        elif [ $temp_pos -gt $temp_bar_width ]; then
            temp_pos=$temp_bar_width
        fi
        
        echo -n "["
        for ((i=0; i<temp_bar_width; i++)); do
            if [ $i -lt $temp_pos ]; then
                if [ $max_temp -ge $HIGH_TEMP ]; then
                    echo -ne "${RED}█${NC}"
                elif [ $max_temp -ge $((HIGH_TEMP - 5)) ]; then
                    echo -ne "${YELLOW}█${NC}"
                else
                    echo -ne "${GREEN}█${NC}"
                fi
            else
                echo -ne "${GRAY}░${NC}"
            fi
        done
        echo "]"
        echo -e "${WHITE}              ${LOW_TEMP}°C         ${HIGH_TEMP}°C${NC}"
    else
        echo -e "${WHITE}Control Status:${NC} ${YELLOW}MANUAL${NC}"
        echo -e "${WHITE}Fixed Speed:${NC} ${MANUAL_SPEED}"
    fi
    
    echo -e "${CYAN}${SEPARATOR}${NC}"
}

# 简单的实时监控
show_monitor() {
    load_config
    clear
    
    while true; do
        detect_hardware
        local max_temp=$(get_max_temperature)
        local fan_status=$(get_fan_status)
        local fan_percent=0
        
        # 计算百分比
        if [ "$fan_status" != "N/A" ] && [ "$fan_status" -ge 0 ] 2>/dev/null; then
            if [ $DETECTED_MAX -gt $DETECTED_MIN ]; then
                fan_percent=$(( (fan_status - DETECTED_MIN) * 100 / (DETECTED_MAX - DETECTED_MIN) ))
            fi
        fi
        
        # 清屏并显示
        clear
        echo -e "${CYAN}${SEPARATOR}${NC}"
        echo -e "${CYAN}    REAL-TIME FAN CONTROL MONITOR    ${NC}"
        echo -e "${CYAN}${SEPARATOR}${NC}"
        echo ""
        
        # 基本信息
        echo -e "${WHITE}Time:${NC} $(date '+%H:%M:%S')"
        echo -e "${WHITE}Max Temperature:${NC} $max_temp°C"
        echo -e "${WHITE}Fan Speed:${NC} $fan_status (${fan_percent}%)"
        echo -e "${WHITE}Control Mode:${NC} $(if [ $AUTO_CONTROL -eq 1 ]; then echo "AUTO"; else echo "MANUAL"; fi)"
        echo -e "${WHITE}Fan Range:${NC} $DETECTED_MIN-$DETECTED_MAX"
        echo ""
        
        # 温度条
        echo -e "${WHITE}Temperature:${NC}"
        local temp_bar_width=30
        local temp_pos=$(( (max_temp - LOW_TEMP) * temp_bar_width / (HIGH_TEMP - LOW_TEMP) ))
        if [ $temp_pos -lt 0 ]; then temp_pos=0; fi
        if [ $temp_pos -gt $temp_bar_width ]; then temp_pos=$temp_bar_width; fi
        
        echo -n "["
        for ((i=0; i<temp_bar_width; i++)); do
            if [ $i -lt $temp_pos ]; then
                if [ $max_temp -ge $HIGH_TEMP ]; then
                    echo -ne "${RED}█${NC}"
                elif [ $max_temp -ge $((HIGH_TEMP - 5)) ]; then
                    echo -ne "${YELLOW}█${NC}"
                else
                    echo -ne "${GREEN}█${NC}"
                fi
            else
                echo -ne "${GRAY}░${NC}"
            fi
        done
        echo "] $max_temp°C"
        
        # 风扇速度条
        if [ "$fan_status" != "N/A" ] && [ $fan_percent -ge 0 ]; then
            echo -e "${WHITE}Fan Speed:${NC}"
            local speed_bar_width=30
            local speed_pos=$((fan_percent * speed_bar_width / 100))
            
            echo -n "["
            for ((i=0; i<speed_bar_width; i++)); do
                if [ $i -lt $speed_pos ]; then
                    if [ $fan_percent -ge 80 ]; then
                        echo -ne "${RED}█${NC}"
                    elif [ $fan_percent -ge 50 ]; then
                        echo -ne "${YELLOW}█${NC}"
                    else
                        echo -ne "${GREEN}█${NC}"
                    fi
                else
                    echo -ne "${GRAY}░${NC}"
                fi
            done
            echo "] $fan_status"
        fi
        echo ""
        
        # 显示所有温度传感器
        local temps=$(get_all_temperatures)
        if [ -n "$temps" ]; then
            echo -e "${WHITE}All Temperature Sensors:${NC}"
            echo -e "$temps"
        fi
        
        echo ""
        echo -e "${CYAN}${SEPARATOR}${NC}"
        echo "Press Ctrl+C to exit"
        echo -e "${CYAN}${SEPARATOR}${NC}"
        
        sleep 2
    done
}

# 测试硬件
test_hardware() {
    echo "${MSG["testing_hardware"]}"
    echo ""
    
    detect_hardware
    
    echo "Thermal Zones:"
    if [ ${#THERMAL_ZONES[@]} -eq 0 ]; then
        echo "  None found"
    else
        for zone in "${THERMAL_ZONES[@]}"; do
            if [ -f "$zone/type" ] && [ -f "$zone/temp" ]; then
                zone_type=$(cat "$zone/type" 2>/dev/null)
                temp=$(cat "$zone/temp" 2>/dev/null)
                if [ $temp -gt 10000 ]; then
                    temp=$((temp / 1000))
                fi
                echo "  $zone_type: ${temp}°C"
            fi
        done
    fi
    
    echo ""
    echo "Cooling Devices:"
    if [ ${#COOLING_DEVICES[@]} -eq 0 ]; then
        echo "  None found"
    else
        for device in "${COOLING_DEVICES[@]}"; do
            device_name=$(basename $device)
            if [ -f "$device/type" ]; then
                device_type=$(cat "$device/type" 2>/dev/null)
                echo "  $device_name: $device_type"
                
                if [ -f "$device/cur_state" ]; then
                    if [ -w "$device/cur_state" ]; then
                        echo "    ✓ Writable"
                    else
                        echo "    ✗ Read-only"
                    fi
                fi
            fi
        done
    fi
}

# 查看日志
view_logs() {
    echo "${MSG["view_logs"]}"
    echo ""
    
    if [ -f "$LOG_FILE" ]; then
        tail -f "$LOG_FILE"
    else
        echo "Log file not found: $LOG_FILE"
    fi
}

# 编辑配置
edit_config() {
    if [ -f "$CONFIG_FILE" ]; then
        ${EDITOR:-nano} "$CONFIG_FILE"
        show_msg "config_updated"
    else
        echo "Config file not found: $CONFIG_FILE"
    fi
}

# 启动守护进程
start_daemon() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if kill -0 $pid 2>/dev/null; then
            show_msg "service_running"
            return 1
        else
            rm -f "$PID_FILE"
        fi
    fi
    
    detect_hardware
    if [ -z "$FAN_DEVICE" ]; then
        echo "Error: No fan device found"
        return 1
    fi
    
    # 后台运行控制循环
    (
        load_config
        DAEMON_MODE=1
        log_message "INFO" "Fan control daemon started"
        
        # 启动时立即应用配置
        local max_temp=$(get_max_temperature)
        local initial_speed=0
        
        if [ $AUTO_CONTROL -eq 1 ]; then
            # 自动模式：根据当前温度计算速度
            initial_speed=$(calculate_fan_speed $max_temp)
            log_message "INFO" "Starting in AUTO mode, initial speed: ${initial_speed} (temp: ${max_temp}°C)"
        else
            # 手动模式：使用固定速度
            initial_speed=$MANUAL_SPEED
            log_message "INFO" "Starting in MANUAL mode, fixed speed: ${initial_speed}"
        fi
        
        # 应用初始速度
        if set_fan_speed $initial_speed; then
            log_message "INFO" "Initial fan speed set to: ${initial_speed}"
        else
            log_message "ERROR" "Failed to set initial fan speed: ${initial_speed}"
        fi
        
        # 主控制循环
        while true; do
            load_config  # 每次循环重新加载配置，支持热更新
            
            local max_temp=$(get_max_temperature)
            if [ $max_temp -gt 0 ]; then
                if [ $AUTO_CONTROL -eq 1 ]; then
                    # 自动控制模式
                    local new_speed=$(calculate_fan_speed $max_temp)
                    if [ $new_speed -ne $CURRENT_SPEED ]; then
                        if set_fan_speed $new_speed; then
                            log_message "INFO" "Temp: ${max_temp}°C, Fan: ${new_speed}"
                        fi
                    fi
                else
                    # 手动控制模式
                    if [ $MANUAL_SPEED -ne $CURRENT_SPEED ]; then
                        if set_fan_speed $MANUAL_SPEED; then
                            log_message "INFO" "Manual mode, Fan: ${MANUAL_SPEED}"
                        fi
                    fi
                fi
            else
                log_message "WARNING" "Could not read temperature"
            fi
            
            sleep $CHECK_INTERVAL
        done
    ) &
    
    echo $! > "$PID_FILE"
    show_msg "daemon_started"
}

# 停止守护进程
stop_daemon() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if kill -0 $pid 2>/dev/null; then
            kill $pid
            show_msg "daemon_stopped"
        else
            show_msg "service_stopped"
        fi
        rm -f "$PID_FILE"
    else
        show_msg "service_stopped"
    fi
}

# 重启守护进程
restart_daemon() {
    stop_daemon
    sleep 2
    start_daemon
    show_msg "daemon_restarted"
}

# 显示帮助
show_help() {
    show_title
    show_msg "usage"
    echo ""
    show_msg "commands"
    echo ""
    show_msg "cmd_install"
    show_msg "cmd_uninstall"
    show_msg "cmd_start"
    show_msg "cmd_stop"
    show_msg "cmd_restart"
    show_msg "cmd_status"
    show_msg "cmd_monitor"
    show_msg "cmd_config"
    show_msg "cmd_menuconfig"
    show_msg "cmd_log"
    show_msg "cmd_test"
    show_msg "cmd_fanstop"
    show_msg "cmd_fanstart"
    show_msg "cmd_detect"
    show_msg "cmd_help"
    echo ""
    
    if [ "$LANG" = "cn" ]; then
        echo "示例:"
        echo "  sudo fan-control install        # 安装程序"
        echo "  sudo fan-control status         # 查看状态"
        echo "  sudo fan-control menu-config    # 交互式配置"
        echo "  sudo fan-control detect         # 检测风扇范围"
        echo "  sudo fan-control fan-stop       # 停止风扇"
        echo "  sudo fan-control monitor        # 实时监控"
        echo ""
        echo "配置文件: $CONFIG_FILE"
        echo "日志文件: $LOG_FILE"
        echo "范围缓存: $RANGE_CACHE_FILE"
        echo ""
        echo "提示: 修改配置后需要重启服务:"
        echo "  sudo fan-control restart"
    else
        echo "Examples:"
        echo "  sudo fan-control install        # Install"
        echo "  sudo fan-control status         # Show status"
        echo "  sudo fan-control menu-config    # Interactive configuration"
        echo "  sudo fan-control detect         # Detect fan range"
        echo "  sudo fan-control fan-stop       # Stop fan"
        echo "  sudo fan-control monitor        # Real-time monitor"
        echo ""
        echo "Config file: $CONFIG_FILE"
        echo "Log file: $LOG_FILE"
        echo "Range cache: $RANGE_CACHE_FILE"
        echo ""
        echo "Tip: Restart service after config changes:"
        echo "  sudo fan-control restart"
    fi
}

# 从参数列表中移除语言参数
clean_language_args() {
    local cleaned_args=()
    local skip_next=0
    
    for arg in "$@"; do
        if [ $skip_next -eq 1 ]; then
            skip_next=0
            continue
        fi
        
        if [ "$arg" = "--lang" ] || [ "$arg" = "-l" ]; then
            skip_next=1
            continue
        fi
        
        cleaned_args+=("$arg")
    done
    
    echo "${cleaned_args[@]}"
}

# ============================================
# 主函数
# ============================================

main() {
    # 初始化语言（按照优先级：命令行参数 > 配置文件 > 默认值）
    init_language "$@"
    
    # 移除命令行中的语言参数，避免影响后续处理
    local args=()
    local skip_next=0
    for ((i=1; i<=$#; i++)); do
        local arg="${!i}"
        
        if [ $skip_next -eq 1 ]; then
            skip_next=0
            continue
        fi
        
        if [ "$arg" = "--lang" ] || [ "$arg" = "-l" ]; then
            skip_next=1
            continue
        fi
        
        args+=("$arg")
    done
    
    # 使用处理后的参数
    set -- "${args[@]}"
    
    # 根据命令执行相应操作
    case "$1" in
        install)
            install_fan_control
            ;;
        uninstall)
            uninstall_fan_control
            ;;
        start)
            check_root
            load_config
            start_daemon
            ;;
        stop)
            check_root
            stop_daemon
            ;;
        restart)
            check_root
            load_config
            restart_daemon
            ;;
        status)
            load_config
            show_status
            ;;
        monitor)
            load_config
            show_monitor
            ;;
        config)
            check_root
            edit_config
            ;;
        menu-config)
            check_root
            show_config_menu
            ;;
        log)
            view_logs
            ;;
        test)
            load_config
            test_hardware
            ;;
        fan-stop)
            check_root
            stop_fan_completely
            ;;
        fan-start)
            check_root
            start_fan_control
            ;;
        detect)
            check_root
            detect_fan_range
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            if [ $# -eq 0 ]; then
                show_help
            else
                echo "Unknown command: $1"
                echo ""
                show_help
                exit 1
            fi
            ;;
    esac
}

# 脚本入口
main "$@"
