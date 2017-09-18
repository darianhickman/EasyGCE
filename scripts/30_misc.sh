
sshd_permit_password_login(){
  sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
}

sshd_permit_password_login
