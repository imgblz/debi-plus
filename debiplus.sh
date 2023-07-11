#!/bin/bash

echo "Debian Network Reinstall Script Plus"

# Prompt for user input
read -p "请输入新系统用户密码: " password

# Check country code from IP-API
country_code=$(curl -s http://ip-api.com/json/ | jq -r '.countryCode')

# Set mirror flag based on country code
if [[ $country_code == "CN" ]]; then
    mirror_flag="--china"
    script_download_command="curl -fLO https://raw.githubusercontents.com/bohanyang/debi/master/debi.sh && chmod a+rx debi.sh"
else
    mirror_flag="--cdn"
    script_download_command="curl -fLO https://raw.githubusercontent.com/bohanyang/debi/master/debi.sh && chmod a+rx debi.sh"
fi

# Prompt for user input
read -p "请输入网络接口名称（默认为eth0）: " interface

# Prompt for user input
read -p "是否启用安装程序的网络控制台？(y/n，默认为否): " enable_network_console

# Set network console flag based on user input
if [[ $enable_network_console == "y" ]]; then
    network_console_flag="--network-console"
else
    network_console_flag=""
fi

# Prompt for user input
read -p "请选择要安装的Debian版本 (10/11/12/13，默认为12): " debian_version

# Set Debian version based on user input
if [[ $debian_version == "10" || $debian_version == "11" || $debian_version == "13" ]]; then
    version_flag="--version $debian_version"
else
    version_flag="--version 12"
fi

# Prompt for user input
read -p "是否开启BBR？(y/n，默认为是): " enable_bbr

# Set BBR flag based on user input
if [[ $enable_bbr == "n" ]]; then
    bbr_flag=""
else
    bbr_flag="--bbr"
fi

# Prompt for user input
read -p "请输入要安装的磁盘路径 (默认为空): " disk

# Set disk flag based on user input
if [[ -n $disk ]]; then
    disk_flag="--disk $disk"
else
    disk_flag=""
fi

# Download script
echo "正在下载脚本..."
eval $script_download_command

echo "运行脚本..."
sudo ./debi.sh $mirror_flag $network_console_flag --ethx $bbr_flag $version_flag $disk_flag --user root --password $password

# Prompt for user input
read -p "(记得检查报错)安装完成后是否立即重启系统？(y/n): " reboot

# Reboot if requested
if [[ $reboot == "y" ]]; then
    echo "重启系统..."
    sudo shutdown -r now
fi

echo "结束QWQ"
