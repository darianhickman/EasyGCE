Start Google Compute Engine and install needed software
===========================

Requirements
------------

  * Google Cloud account
  * Installed [google cloud SDK](https://cloud.google.com/sdk/downloads) on computer running script.
  * Also must be authenticated with Google Cloud. It can be done by using `gcloud auth login` command.

Install
-------

  * Essential tools
    * git
    * wget
  * Webservers
    * nginx
    * caddy
  * Cloud provider cli tools
    * google cloud 
    * aws
    * azure
  * Browser
    * Chrome
  * Desktop environment
    * xfce4
  * Remote desktops
    * xrdp -- running with remote desktop protocol. Good for Windows Remote Desktop client
    * tightvncserver
  * Misc
    * filezilla
    * wetty -- web shell. Access web shell on `http://server_ip_or_domain/wetty/ssh/username` . [Docs](https://github.com/krishnasrinivas/wetty)

Firewall settings for google cloud
----------------------------------
  
  * Script will open ports:
    * 22/tcp -- ssh
    * 80/tcp -- http
    * 443/tcp -- https
    * 3389/tcp -- remote desktop protocol
    * 5901/tcp -- vnc server
  * Ports can be changed in `create_gce_vm.sh` script.
    * For ports to be changed GCE\_VM\_OPEN\_PORTS list needs to be changed with appropriate entries. Correct format is `protocol:portNumber`

Variables
---------

  * 
