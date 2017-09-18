# Easy GCE project

  * Repository: https://github.com/darianhickman/EasyGCE
  * Original Design doc [link](https://docs.google.com/document/d/e/2PACX-1vT09bWt4C-b1MDaAZhAcG9We5RC1_nxlJfAYsAXhQHj37iXQ5NnnwraFQ6VX8EFr-k8sg1xehXxT2W6/pub)

  *Problem:*
    * Many saas offerings make it pain in the ass to download files or objects via commandline or require paid memberships to access API's

  *Goal:*
    * Make it insanely easy to download files from anywhere and to then scp/stps/cli to any server on-premise and in cloud and in the storage services like S3, Google Storage.


## Tactic

  * Dockerize a server that enables Remote Desktop. [Possible solution](https://hub.docker.com/r/consol/ubuntu-xfce-vnc)
  * Install
    * google cloud sdk
    * aws sdk
    * azure sdk
    * Gnome or XFCE
    * Google Chrome
    * Cyberduck if it exists for Linux
    * Install fast web server with directory browsing enabled for the highest level folder possible “/”
    * Install web service to edit text files on the file system with sudo privs
    * If a web version of SublimeText exists, install that
    * Install a web shell
    * If bash as a web app exists install that. [Possible solution](https://github.com/takluyver/bash_kernel)
    * Install  a fast VNC Server or better server for enabling Remote Desktop
    * Turn off / disable iptables
    * Config files and service scripts necessary
  * Update Google Cloud Firewall rules by script to open  up all relevant ports and protocols

## Tests

  * Connect to Server with Vnc Viewer
  * Connect to Server with the Remote Desktop baked into MacOS
  * Connect to Server with Chrome Remote Desktop
  * Download a large file from a free  Google Drive account without first downloading to desktop system
  * Download a large file from Box.com directly to server
  * Download a large file from a free Dropbox.com account
  * Upload a file to Google Storage bucket
  * Upload a file to Amazon S3 bucket

## Stuff that Failed

  * VNCServer from https://www.realvnc.com/en/connect/download/vnc/linux/
  * https://github.com/queeno/docker-ubuntu-desktop
  * https://medium.com/google-cloud/linux-gui-on-the-google-cloud-platform-800719ab27c5
  * https://medium.com/google-cloud/graphical-user-interface-gui-for-google-compute-engine-instance-78fccda09e5c
  * https://www.youtube.com/watch?v=sT9JUL7q2uM
