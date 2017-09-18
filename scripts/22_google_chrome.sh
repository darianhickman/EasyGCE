
install_google_chrome(){
  # add key
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  # add ppa
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
  # update and install
  sudo apt-get update && sudo apt-get --assume-yes install google-chrome-stable
}

install_google_chrome
