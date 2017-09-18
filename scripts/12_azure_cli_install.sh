
install_azure_cli(){
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
  sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
  sudo apt-get --assume-yes install apt-transport-https
  sudo apt-get update && sudo apt-get --assume-yes install azure-cli
}

install_azure_cli
