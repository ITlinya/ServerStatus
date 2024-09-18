客户端安装：
'''
wget --no-check-certificate -qO- https://raw.githubusercontent.com/ITlinya/ServerStatus/main/install_client.sh | bash -ex
'''
配置服务端地址：
'''
sed -i 's|http://127.0.0.1:8080/report|http://192.9.130.116:8080/report|' /etc/systemd/system/stat_client.service
sed -i 's|-u h1 -p p1|-u 99 -p asd112233|' /etc/systemd/system/stat_client.service
systemctl daemon-reload
systemctl restart stat_client
'''
