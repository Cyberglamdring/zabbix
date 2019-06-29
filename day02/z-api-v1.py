import requests
import json

from requests.auth import HTTPBasicAuth

zabbix_server = "192.168.50.100"
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"


def post(request):
    headers = {'content-type': 'application/json'}
    return requests.post(
        "http://" + zabbix_server + "/api_jsonrpc.php",
        data=json.dumps(request),
        headers=headers,
        auth=HTTPBasicAuth(zabbix_api_admin_name, zabbix_api_admin_password)
    )


auth_token = post({
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": zabbix_api_admin_name,
        "password": zabbix_api_admin_password
    },
    "auth": None,
    "id": 0}
).json()["result"]


def register_group():
    post({
        "jsonrpc": "2.0",
        "method": "hostgroup.create",
        "params": {
            "name": "CloudHosts2"
        },
        "auth": auth_token,
        "id": 1
    })


def register_host(hostname="Tomcat22", ip="192.168.50.101"):
    post({
        "jsonrpc": "2.0",
        "method": "host.create",
        "params": {
            "host": hostname,
            "templates": [{
                "templateid": "10001"  # Tamplate OS Linux
            }],
            "interfaces": [{
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": ip,
                "dns": "",
                "port": "10050"
            }],
            "groups": [
                {
                    "groupid": "12"
                }
            ]
        },
        "auth": auth_token,
        "id": 1
    })
