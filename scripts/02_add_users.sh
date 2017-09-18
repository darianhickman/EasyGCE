
add_users(){
  grep ubuntu /etc/passwd || sudo useradd -m ubuntu
  sudo usermod -aG adm ubuntu
  echo "ubuntu:21436587" | chpasswd
  echo "ubuntu ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ubuntu
}

add_users
