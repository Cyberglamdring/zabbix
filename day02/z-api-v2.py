from pyzabbix import ZabbixAPI

zapi = ZabbixAPI("http://192.168.50.100")
zapi.login("Admin", "zabbix")

zapi.hostgroup.create({
    "name": "CloudHosts-2"
})

zapi.host.create({
                "host": "Tomcat-2",
                "interfaces":
                [{
                        "type": 1,
                        "main": 1,
                        "useip": 1,
                        "ip": "192.168.50.101",
                        "dns": "",
                        "port": 10050
                }],
                "groups": [{
                    "groupid": "12"
                }],
                "templates": [{
                    "templateid": '10001'
                }],
        })
