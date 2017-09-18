
sudo systemctl daemon-reload
sudo systemctl restart sshd
sudo systemctl start xrdp
sudo systemctl enable xrdp
sudo systemctl start wetty
sudo systemctl enable wetty
sudo systemctl start caddy
sudo systemctl enable caddy
#sudo systemctl start nginx
#sudo systemctl enable nginx
sudo systemctl start tightvncserver
sudo systemctl enable tightvncserver
sudo reboot
