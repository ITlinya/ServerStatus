#!/bin/bash
set -ex
WORKSPACE=/opt/ServerStatus
mkdir -p ${WORKSPACE}
cd ${WORKSPACE}
# 安装 unzip
if [ -x "$(command -v yum)" ]; then
    yum install -y unzip
elif [ -x "$(command -v apt-get)" ]; then
    apt-get update
    apt-get install -y unzip
else
    echo "不支持的操作系统，请手动安装 unzip"
    exit 1
fi
# 设置 OS_ARCH
ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
    OS_ARCH="x86_64"
elif [ "$ARCH" == "aarch64" ]; then
    OS_ARCH="aarch64"
else
    echo "不支持的架构: $ARCH"
    exit 1
fi
# 获取最新版本号
latest_version=$(curl -m 10 -sL "https://proxy.lblog.net/https://api.github.com/repos/zdz/ServerStatus-Rust/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')
# 下载对应架构的文件
wget --no-check-certificate -qO "client-${OS_ARCH}-unknown-linux-musl.zip"  "https://proxy.lblog.net/https://github.com/zdz/ServerStatus-Rust/releases/download/${latest_version}/client-${OS_ARCH}-unknown-linux-musl.zip"
unzip -o "client-${OS_ARCH}-unknown-linux-musl.zip"
mv -v stat_client.service /etc/systemd/system/stat_client.service
systemctl daemon-reload
systemctl start stat_client
systemctl status stat_client
# 使用以下命令开机自启
systemctl enable stat_client

# vi /etc/systemd/system/stat_client.service 文件，将IP改为你服务器的IP或你的域名
