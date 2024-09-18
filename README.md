客户端安装
```
wget --no-check-certificate -qO- https://raw.githubusercontent.com/ITlinya/ServerStatus/main/install_client.sh | bash -ex

```
修改服务端地址：
```
sed -i 's|http://127.0.0.1:8080/report|http://192.168.1.1:8080/report|' /etc/systemd/system/stat_client.service
sed -i 's|-u h1 -p p1|-u 9527 -p 112233|' /etc/systemd/system/stat_client.service
systemctl daemon-reload
systemctl restart stat_client
```
回调地址示例http://192.168.1.1:8080/report自行修改，账号9527密码112233自行修改
