#!/bin/bash
# access to remote logging
sudo sed -i '73a\EnableRemoteCommands=1' /etc/zabbix/zabbix_agentd.conf
# remote logging ON
sudo sed -i '82a\LogRemoteCommands=1' /etc/zabbix/zabbix_agentd.conf
# launch as root
sudo sed -i '256a\AllowRoot=1' /etc/zabbix/zabbix_agentd.conf

