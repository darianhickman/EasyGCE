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

  * `gce_server_deploy.sh` script variables
    * GCE\_PROJECT -- name of GCE project in which to deploy server. Default project is not set.
    * GCE\_MACHINE\_TYPE -- size of virtual machine. Default VM size is `n1-standard-2`
    * GCE\_VM\_NAME -- name of VM. Default name if not specified is `GCE_PROJECT-timestamp_in_seconds`
    * GCE\_VM\_IMAGE\_PROJECT -- OS image project. Default `ubuntu-os-cloud`
    * GCE\_VM\_IMAGE -- OS for VM. Default `ubuntu-1604`
    * GCE\_VM\_ZONE -- zone where VM will be provisioned. Default `us-east1-c`
    * GCE\_VM\_STARTUP\_SCRIPT -- location of temporary script for provisioning server. Default `/tmp/startupscript.sh`
    * GCE\_BOOT\_DISK\_SIZE -- size of boot disk. Default `30GB`
    * GCE\_BOOT\_DISK\_TYPE -- type of boot disk. Default `pd-ssd` -- persistent ssd
    * GCE\_BOOT\_DISK\_AUTO\_DELETE -- behaviour of boot disk if VM is destroyed. Default is to keep disk when VM is destroyed. To delete disk when machine is destroyed delete this variable or set it to empty value
    * GCE\_OPEN\_INBOUND\_PORTS -- ports open in GCE project. Default `TCP 22 80 443 3389 5901`

Script usage
------------

  * Running `gce_server_deploy.sh` script without arguments will list script usage.
