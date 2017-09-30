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
GCE_OPEN_INBOUND_PORTS='22 80 443 3389 5901 6901'

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

while getopts "p:m:n:z:i:h" opt; do
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
        h)
            usage
            exit
            ;;
        *)
            usage
            exit
            ;;
    esac
done
shift $((OPTIND-1))

if [[ -z ${GCE_PROJECT} ]];
    GCE_PROJECT=${GCE_PROJECT} || { echo -e "\n\tERROR: gce project not specified"; exit 1; }
fi
if [[ -z ${GCE_VM_NAME} ]]; then
    GCE_VM_NAME=${GCE_PROJECT}-$(date +%s)
fi

#####
##### functions
#####

gce_create_startup_script(){
  ##
  ## install docker on server start up
  ##
  # empty script if already exists
  cat > ${GCE_VM_STARTUP_SCRIPT} <<EOF
# basic update/upgrade
apt-get update && apt-get --assume-yes upgrade
# install docker and git
apt-get --assume-yes install apt-transport-https ca-certificates curl software-properties-common git
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable"
apt-get update
apt-get --assume-yes install -y docker-ce
# clone easygce repo
mkdir -p /opt/easygce
git clone https://github.com/darianhickman/easygce /opt/easygce
cd /opt/easygce/docker && docker build -t easygce:1.0 .
docker run -d --restart on-failure -p 3389:3389 -p 80:80 -p 5901:5901 -p 6901:6901 easygce:1.0
EOF
}

gce_set_project(){
  # set google cloud project
  gcloud config set project ${GCE_PROJECT}
}

gce_add_firewall_rules(){
  open_ports=$(gcloud compute firewall-rules list --format="table(allowed[].ports, direction, sourceRanges)" | grep 0.0.0.0 | grep -Eo "[0-9]{2,5}" | uniq)
  for port in ${GCE_OPEN_INBOUND_PORTS}; do
      if [[ ! $(echo $open_ports | grep $port ) ]]; then
          gcloud compute firewall-rules create inbound-tcp-${port} --action allow \
              --rules tcp:${port} --direction INGRESS --priority 14${port:0:3}
      fi
  done
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
  echo -e "\n easygce instance ip: $(gcloud compute instances list | sed -n \"/${GCE_VM_NAME}/p\" | awk '{ print $5 }')"
}

main
