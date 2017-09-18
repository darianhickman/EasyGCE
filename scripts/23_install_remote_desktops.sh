
install_xrdp(){
  sudo apt-get --assume-yes install xrdp
}

install_vnc(){
  sudo apt-get --assume-yes install tightvncserver
  # add tightvncserver systemd service
  sudo cat > /lib/systemd/system/tightvncserver.service <<EOF
[Unit]
Description=TightVNC remote desktop server
After=sshd.service

[Service]
Type=dbus
ExecStart=/usr/bin/tightvncserver :1
User=ubuntu
Type=forking

[Install]
WantedBy=multi-user.target
EOF
}

install_xrdp
install_vnc
