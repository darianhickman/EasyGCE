
install_wetty(){
  # install nodejs and npm
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  sudo apt-get install --assume-yes nodejs
  sudo apt-get install --assume-yes npm
  # pull from github and do npm install
  if [[ ! -d /opt/wetty ]]; then
    sudo mkdir -p /opt/wetty 
    git clone https://github.com/krishnasrinivas/wetty /opt/wetty
  else
    cd /opt/wetty && git pull
  fi
  cd /opt/wetty && npm install
  # create wetty service file
  sudo cat > /lib/systemd/system/wetty.service <<EOF
[Unit]
Description=web shell
Documentation=https://github.com/krishnasrinivas/wetty
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/wetty
ExecStart=/usr/bin/node app.js -p 3000
User=ubuntu
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
  # create nginx configuration if nginx is installed
#  [ $(which nginx) ] && \
#  sudo cat > /etc/nginx/conf.d/wgetty.conf <<EOF
#server{
#  listen 80;
#  server_name _;
#  location /wetty {
#    if ( \$request_uri ~ root ) {
#      return 403;
#    }
#    proxy_pass http://127.0.0.1:3000/wetty;
#    proxy_http_version 1.1;
#    proxy_set_header Upgrade \$http_upgrade;
#    proxy_set_header Connection "upgrade";
#    proxy_read_timeout 43200000;
#
#    proxy_set_header X-Real-IP \$remote_addr;
#    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#    proxy_set_header Host \$http_host;
#    proxy_set_header X-NginX-Proxy true;
#  }
#}
#EOF
#  # reload nginx configuration
#  sudo nginx -s reload
}

install_wetty
