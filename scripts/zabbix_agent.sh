#!/bin/bash
# 0: installing Zabbix Agent
sudo yum install -y http://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-1.el7.noarch.rpm
sudo yum install -y zabbix-agent
# config Agent
sudo sed -i '98a\Server=192.168.50.100\nListenPort=10050\nListenIP=0.0.0.0\nStartAgents=3\n' /etc/zabbix/zabbix_agentd.conf
sudo sed -i '98d' /etc/zabbix/zabbix_agentd.conf
# enable service
sudo systemctl start zabbix-agent
sudo systemctl enable zabbix-agent

