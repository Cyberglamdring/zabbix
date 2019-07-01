#!/bin/bash
sudo tee /etc/systemd/system/auto_z_scr.service << EOF
[Unit]
Description=Routing Settings Service
After=network.target

[Service]
Type=oneshot
User=root
ExecStart=~/py-zab-scr.sh

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 664 /etc/systemd/system/auto_z_scr.service

sudo systemctl start auto_z_scr.service
systemctl enable auto_z_scr.service
