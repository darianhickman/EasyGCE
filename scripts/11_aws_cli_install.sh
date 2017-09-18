
install_aws_cli(){
  sudo apt-get --assume-yes install python-pip
  pip install awscli --upgrade --user
}

install_aws_cli
