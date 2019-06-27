# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.define "zabbix-srv" do |zabbixsrv|
        zabbixsrv.vm.box = "sbeliakou/centos"
	zabbixsrv.vm.box_check_update = false
    	zabbixsrv.vm.network :private_network, ip: "192.168.50.100"
    	zabbixsrv.vm.hostname = "zabbix-srv"
    	zabbixsrv.ssh.insert_key = false

	zabbixsrv.vm.provider "virtualbox" do |vb|
            vb.name = "zabbix-srv"
            vb.memory = "1024"
        end
    zabbixsrv.vm.provision "shell", path: "scripts/zabbix_srv.sh"
    end

    config.vm.define "zabbix-agent" do |zabbixagent|
	zabbixagent.vm.box = "sbeliakou/centos"
    	zabbixagent.vm.box_check_update = false
    	zabbixagent.vm.network :private_network, ip: "192.168.50.101"
    	zabbixagent.vm.hostname = "zabbix-agent"
    	zabbixagent.ssh.insert_key = false
  
    	zabbixagent.vm.provider "virtualbox" do |vb|
            vb.name = "zabbix-agent"
            vb.memory = "1024"
        end
    zabbixagent.vm.provision "shell", path: "scripts/nginx_install.sh"
    zabbixagent.vm.provision "shell", path: "scripts/tomcat_install.sh"
    zabbixagent.vm.provision "shell", path: "scripts/zabbix_agent.sh"
    end
end
