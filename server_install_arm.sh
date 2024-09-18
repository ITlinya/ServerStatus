#!/bin/bash
set -ex
WORKSPACE=/opt/ServerStatus
mkdir -p ${WORKSPACE}
cd ${WORKSPACE}

# 判断操作系统并安装 unzip
if [ -x "$(command -v yum)" ]; then
    yum install -y unzip
elif [ -x "$(command -v apt-get)" ]; then
    apt-get update
    apt-get install -y unzip
else
    echo "请自行手动安装 unzip"
    exit 1
fi

# 下载, arm 机器替换 x86_64 为 aarch64
OS_ARCH="aarch64"
latest_version=$(curl -m 10 -sL "https://api.github.com/repos/zdz/ServerStatus-Rust/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')
wget --no-check-certificate -qO "server-${OS_ARCH}-unknown-linux-musl.zip"  "https://github.com/zdz/ServerStatus-Rust/releases/download/${latest_version}/server-${OS_ARCH}-unknown-linux-musl.zip"

# 解压文件
unzip -o "server-${OS_ARCH}-unknown-linux-musl.zip"

# systemd service
mv -v stat_server.service /etc/systemd/system/stat_server.service
systemctl daemon-reload

# 启动服务
systemctl start stat_server

# 查看服务状态
systemctl status stat_server

# 设置开机自启
systemctl enable stat_server
