#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    echo "请使用root权限运行此脚本。"
    exit 1
fi

if command -v apt-get > /dev/null; then
    package_manager="apt"
elif command -v yum > /dev/null; then
    package_manager="yum"
else
    echo "不支持的系统类型 仅支持APT和YUM软件包管理"
    exit 1
fi

if [ "$package_manager" = "apt" ]; then
    echo "正在更新系统软件包......"
    apt-get update > /dev/null
    apt-get upgrade -y > /dev/null
    apt-get install -y make gcc git autoconf libssl-dev zlib1g-dev > /dev/null
elif [ "$package_manager" = "yum" ]; then
    echo "正在更新系统软件包......"
    yum update -y > /dev/null
    yum upgrade -y > /dev/null
    yum install -y make gcc git autoconf openssl-devel zlib-devel > /dev/null
fi
echo "开始更新, 耐心等待"
temp_dir=$(mktemp -d)
git clone https://github.com/openssh/openssh-portable "$temp_dir"
clear
cd "$temp_dir" || exit
autoreconf > /dev/null 2>&1
./configure > /dev/null 2>&1
make > /dev/null 2>&1
make install > /dev/null 2>&1
rm -rf "$temp_dir"
. /etc/profile
clear
ssh -V
echo "OpenSSH升级成功"
