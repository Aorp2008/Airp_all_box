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
    apt-get update
    apt-get upgrade -y
    apt-get install -y make gcc git autoconf libssl-dev zlib1g-dev
elif [ "$package_manager" = "yum" ]; then
    yum update -y
    yum upgrade -y
    yum install -y make gcc git autoconf openssl-devel zlib-devel
fi
temp_dir=$(mktemp -d)
git clone https://github.com/openssh/openssh-portable "$temp_dir"
cd "$temp_dir" || exit
autoreconf
./configure
make
make install
rm -rf "$temp_dir"
source /etc/profile
ssh -V
echo "OpenSSH升级成功"
