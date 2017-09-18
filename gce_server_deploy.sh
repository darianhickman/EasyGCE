#!/bin/bash

#####
##### google cloud engine variables
#####

## set defaults

# project
GCE_PROJECT=
# vm
GCE_MACHINE_TYPE=n1-standard-2
GCE_VM_NAME=
GCE_VM_IMAGE_PROJECT=ubuntu-os-cloud
GCE_VM_IMAGE=ubuntu-1604-xenial-v20170815a
GCE_VM_ZONE=us-east1-c
GCE_VM_STARTUP_SCRIPT=/tmp/startupscript.sh
# disks
GCE_BOOT_DISK_SIZE=30GB
GCE_BOOT_DISK_TYPE=pd-ssd
GCE_BOOT_DISK_AUTO_DELETE=--no-boot-disk-auto-delete
# firewall
GCE_OPEN_INBOUND_PORTS='tcp:22 tcp:80 tcp:443 tcp:3389 tcp:5901'

usage(){
  cat <<-EOF

Usage: $0 -p <gce_project_name> -m <gce_machine_type> -n <gce_machine_name> -z <gce_machine_zone> -i <gce_project_open_ports> 

Default values:
  gce_project_name NONE
  gce_machine_type n1-standard-2
  gce_machine_name gce_project_name+<date_in_seconds>
  gce_machine_zone us-east1-c
  gce_project_open_ports tcp ports 22,80,443,3389,5901
EOF
}

if [[ $# -eq 0 ]]; then
    usage
    exit
fi

while getopts "p:m:n:z:i:" opt; do
    case "${opt}" in
        p)
            GCE_PROJECT=${OPTARG}
            ;;
        m)
            GCE_MACHINE_TYPE=${OPTARG}
            ;;
        n)
            GCE_VM_NAME=${OPTARG}
            ;;
        z)
            GCE_VM_ZONE=${OPTARG}
            ;;
        i)
            GCE_OPEN_INBOUND_PORTS=${OPTARG}
            ;;
        *)
            usage
            exit
            ;;
    esac
done
shift $((OPTIND-1))

if [[ -z ${GCE_VM_NAME} ]]; then
    GCE_VM_NAME=${GCE_PROJECT}-$(date +%s)
fi

#####
##### functions
#####

gce_create_startup_script(){
  ##
  ## create one startup script from all scripts in scripts direcotry
  ##
  # empty script if already exists
  > ${GCE_VM_STARTUP_SCRIPT}
  # concatenate all scripts from scripts directory into one
  SCRIPTS_DIR="$(dirname "$(readlink -e ${BASH_SOURCE[0]})")/scripts"
  for script in ${SCRIPTS_DIR}/*; do
    cat $script >> ${GCE_VM_STARTUP_SCRIPT}
  done
}

gce_set_project(){
  # set google cloud project
  gcloud config set project ${GCE_PROJECT}
}

gce_add_firewall_rules(){
  # check if firewall rule already exists
  gcloud compute firewall-rules list | grep $(echo ${GCE_OPEN_INBOUND_PORTS} | sed 's/[: ]/-/g') && return 0 || true
  # add firewall rules
  gcloud compute firewall-rules create inbound-$(echo ${GCE_OPEN_INBOUND_PORTS} | sed 's/[: ]/-/g') \
    --action allow \
    --rules $(echo ${GCE_OPEN_INBOUND_PORTS} | sed 's/ /,/g' ) \
    --direction INGRESS --priority 1010
}

gce_create_instance(){
  # create instance
  gcloud compute instances create ${GCE_VM_NAME} \
      ${GCE_BOOT_DISK_AUTO_DELETE} \
      --boot-disk-size ${GCE_BOOT_DISK_SIZE} \
      --boot-disk-type ${GCE_BOOT_DISK_TYPE} \
      --image-project ${GCE_VM_IMAGE_PROJECT} \
      --image ${GCE_VM_IMAGE} \
      --machine-type ${GCE_MACHINE_TYPE} \
      --zone ${GCE_VM_ZONE} \
      --metadata-from-file startup-script=${GCE_VM_STARTUP_SCRIPT}
}

main(){
  gce_create_startup_script
  gce_set_project
  gce_add_firewall_rules
  gce_create_instance
}

main
