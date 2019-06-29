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

#--------------------day-02------------------
# JAVA OPTS
JAVA_OPTS="${JAVA_OPTS} \
    -Dcom.sun.management.jmxremote \
    -Djava.rmi.server.hostname=192.168.50.101 \  
    -Dcom.sun.management.jmxremote.local.only=false \  
    -Dcom.sun.management.jmxremote.port=12345 \  
    -Dcom.sun.management.jmxremote.rmi.port=12346 \  
    -Dcom.sun.management.jmxremote.authenticate=false \  
    -Dcom.sun.management.jmxremote.ssl=false"

# addin lib
cd ~/
sudo wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.42/bin/extras/catalina-jmx-remote.jar
sudo cp catalina-jmx-remote.jar /opt/apache-tomcat-8.5.42/lib/
sudo chown -R tomcat:tomcat /opt/apache-tomcat-8.5.42/
rm -f catalina-jmx-remote.jar

# confif tomcat server.xml
sudo sed -i '33a\  <Listener className=\"org.apache.catalina.mbeans.JmxRemoteLifecycleListener\"\n            rmiRegistryPortPlatform=\"8097\"\n            rmiServerPortPlatform=\"8098\"\n            rmiBindAddress=\"192.168.56.100\" />' /opt/apache-tomcat-8.5.42/conf/server.xml

# jar
wget https://github.com/jiaqi/jmxterm/releases/download/v1.0.0/jmxterm-1.0.0-uber.jar
sudo java -jar jmxterm-1.0.0-uber.jar -n -l 192.168.50.101:8097
sudo java -jar jmxterm-1.0.0-uber.jar -n -l 192.168.50.101:12345
