
install_nginx(){
  # add nginx source list
  sudo cat > /etc/apt/sources.list.d/nginx.list <<EOF
deb http://nginx.org/packages/ubuntu/ xenial nginx
deb-src http://nginx.org/packages/ubuntu/ xenial nginx
EOF
  # install nginx
  sudo apt-get update && sudo apt-get --allow-unauthenticated --assume-yes install nginx
  # disable default config files
  if [[ -f /etc/nginx/conf.d/default.conf ]]; then
    echo | sudo tee /etc/nginx/conf.d/default.conf
  fi
  if [[ -f /etc/nginx/sites-enabled/default ]]; then
    echo | sudo tee /etc/nginx/sites-enabled/default
  fi
}

install_nginx
