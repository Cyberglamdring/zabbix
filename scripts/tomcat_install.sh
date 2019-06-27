#!/bin/bash
# 0: download java
cd ~/
download java 12
wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie"   "https://download.oracle.com/otn-pub/java/jdk/12.0.1+12/69cfe15208a647278a19ef0990eea691/jdk-12.0.1_linux-x64_bin.rpm"
# 1: installing
sudo rpm -Uvh jdk-12.0.1_linux-x64_bin.rpm
# 2: export dependencies 
export JAVA_HOME=/usr/java/jdk-12.0.1
export PATH=$PATH:/usr/java/jdk-12.0.1/bin
# 3: cleanup
rm ~/jdk-12.0.1_linux-x64_bin.rpm

# 4: download tomcat
sudo wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.42/bin/apache-tomcat-8.5.42.tar.gz
sudo tar -xzvf apache-tomcat-8.5.42.tar.gz -C /opt
sudo rm -f apache-tomcat-8.5.42.tar.gz 

# 5: create user tomcat:tomcat
sudo groupadd tomcat
sudo useradd -g tomcat -d /opt/apache-tomcat-8.5.42 -s /bin/nologin tomcat

# 6: set permissions on folder
sudo chown -R tomcat:tomcat /opt/apache-tomcat-8.5.42/

# 7: create daemon
sudo tee /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Apache Tomcat 9
After=syslog.target network.target

[Service]
User=tomcat
Group=tomcat
Type=forking
Environment=CATALINA_PID=/opt/apache-tomcat-8.5.42/tomcat.pid
Environment=CATALINA_HOME=/opt/apache-tomcat-8.5.42
Environment=CATALINA_BASE=/opt/apache-tomcat-8.5.42
Environment=CATALINA_OPTS=-Xms256m -Xmx512m -verbose:gc -Xloggc:/opt/apache-tomcat-8.5.42/logs/jvm_gc_%p.log -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/apache-tomcat-8.5.42/logs/heap_dump_%p.log
Environment=JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom
ExecStart=/opt/apache-tomcat-8.5.42/bin/startup.sh
ExecStop=/opt/apache-tomcat-8.5.42/bin/shutdown.sh
Restart=on-failure

[Install] 
WantedBy=multi-user.target
EOF

# 8: set rolename
# login/password: admin
sudo tee /opt/apache-tomcat-8.5.42/conf/tomcat-users.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">

        <role rolename="admin-gui"/>
        <role rolename="manager-gui"/>
        <user username="admin" password="admin" roles="admin-gui,manager-gui"/>
</tomcat-users>
EOF

# 9: mange rolename
sudo tee /opt/apache-tomcat-8.5.42/webapps/manager/META-INF/context.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<Context antiResourceLocking="false" privileged="true" >
<!--
     <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
-->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
EOF

# 10: set CATALINA_HOME
export CATALINA_HOME=/opt/apache-tomcat-8.5.42

# 11: run service
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
