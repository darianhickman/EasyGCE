
install_caddy(){
  # install caddy
  curl https://getcaddy.com | sudo bash -s personal http.forwardproxy,http.realip,http.browse,net,http.proxy
  # create caddy service
  sudo cat > /lib/systemd/system/caddy.service <<EOF
[Unit]
Description=caddy webserver
Documentation=https://caddyserver.com/docs
After=network.target

[Service]
Type=simple
Exec=/usr/local/bin/caddy Caddyfile
WorkingDir=/
User=ubuntu
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
}

caddyfile(){
  sudo cat > /Caddyfile <<EOF
:80 {
proxy /wetty localhost:3000
browse /
log /var/log/caddy/access.log
error /var/log/caddy/error.log
}
EOF
}

install_caddy
caddyfile
