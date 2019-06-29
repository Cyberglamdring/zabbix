#!/bin/bash
# 0: installing MySQL
sudo yum install mariadb mariadb-server -y
# configurating
sudo /usr/bin/mysql_install_db --user=mysql
# enable service
sudo systemctl start mariadb
sudo systemctl enable mariadb
# creating db
mysql -uroot <<EOF
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
EOF

# 1: installing Zabbix
sudo yum install -y http://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-1.el7.noarch.rpm
sudo yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent zabbix-get zabbix-sender
# import initial schema and data
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pzabbix zabbix
# configurate
sudo sed -i '$ a DBHost=localhost\nDBName=zabbix\nDBUser=zabbix\nDBPassword=zabbix' /etc/zabbix/zabbix_server.conf
# enable service
sudo systemctl start zabbix-server
sudo systemctl enable zabbix-server
# set backend conf
sudo sed -i '20a\        php_value date.timezone Europe/Minsk\' /etc/httpd/conf.d/zabbix.conf
sudo sed -i '20d' /etc/httpd/conf.d/zabbix.conf
# change 192.168.50.100/zabbix to zabbix
udo sed -i '$ a \\n<VirtualHost *:80>\n    DocumentRoot \"/usr/share/zabbix\"\n    ServerName zabbix-srv\n</VirtualHost>' /etc/httpd/conf.d/zabbix.conf
# start httpd service
sudo systemctl start httpd
sudo systemctl enable httpd

# -------day-02---------
# installing zabbix-java-gateway
sudo yum install -y zabbix-java-gateway

# enable service zabbix-java-gateway
sudo systemctl start zabbix-java-gateway
sudo systemctl enable zabbix-java-gateway

# modifing zabbix_server.conf
sudo sed -i '288a\JavaGateway=192.168.50.100' /etc/zabbix/zabbix_server.conf
sudo sed -i '297a\JavaGatewayPort=10052' /etc/zabbix/zabbix_server.conf
sudo sed -i '306a\StartJavaPollers=5' /etc/zabbix/zabbix_server.conf

