#!/bin/bash
# 0: install nginx from repo
sudo yum install nginx -y

# 1: configurate nginx
sudo tee /etc/nginx/nginx.conf <<EOF
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;
}
EOF

# set proxy on tomcat
sudo tee /etc/nginx/conf.d/tomcat.conf <<EOF
server {
    listen 80;
    server_name zabbixepam.com;

    location / {
            proxy_redirect      off;
            proxy_pass          http://localhost:8080;
    }
}
EOF

# 2: run service
sudo systemctl enable nginx
sudo systemctl start nginx
