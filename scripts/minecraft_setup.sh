#!/bin/bash

apt-get install -y openjdk-21-jre-headless curl wget

mkdir -p /opt/minecraft/server
curl -o /opt/minecraft/server/server.jar https://piston-data.mojang.com/v1/objects/97ccd4c0ed3f81bbb7bfacddd1090b0c56f9bc51/server.jar

echo "eula=true" > /opt/minecraft/server/eula.txt
echo "[Unit]
Description=Minecraft Server
After=network.target

[Service]
WorkingDirectory=/opt/minecraft/server
ExecStart=/usr/bin/java -jar server.jar nogui
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/minecraft.service

systemctl daemon-reload
systemctl enable minecraft
systemctl start minecraft
