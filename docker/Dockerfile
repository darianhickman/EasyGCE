# This Dockerfile is used to build an headles vnc image based on Ubuntu
FROM ubuntu:16.04

ENV REFRESHED_AT 2017-09-14

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901 \
    UBUNTU_USER_PASSWORD=23456789
EXPOSE $VNC_PORT $NO_VNC_PORT 80 3389

## User create
RUN useradd -s /bin/bash -m ubuntu && mkdir /etc/sudoers.d \
    && echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu \
    && echo "ubuntu:$UBUNTU_USER_PASSWORD" | chpasswd

### Envrionment config
ENV HOME=/home/ubuntu \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=$HOME/install \
    NO_VNC_HOME=$HOME/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1920x1080 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

### Add all install scripts for further steps
ADD ./src/common/install/ $INST_SCRIPTS/
ADD ./src/ubuntu/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install some common tools
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### Install firefox and chrome browser
RUN $INST_SCRIPTS/firefox.sh
RUN $INST_SCRIPTS/chrome.sh

### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./src/common/xfce/ $HOME/

### configure startup
RUN $INST_SCRIPTS/libnss_wrapper.sh
ADD ./src/common/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

### Install EasyGCE dependencies
RUN apt-get --assume-yes install git python-pip xrdp curl apt-transport-https sudo openssh-server supervisor \
    && echo "deb http://packages.cloud.google.com/apt cloud-sdk-xenial main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && pip install awscli --upgrade --user \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" > /etc/apt/sources.list.d/azure-cli.list \
    && apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893 \
    && curl https://getcaddy.com | /bin/bash -s personal net \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && mkdir -p /opt/wetty && git clone https://github.com/krishnasrinivas/wetty /opt/wetty \
    && apt-get update && apt-get install --assume-yes google-cloud-sdk azure-cli nodejs filezilla

### Download Azure Storage Explorer and set home directory permissions
COPY ./src/azure-icon-250x250.png /home/ubuntu/azure_icon.png
COPY ./src/common/scripts/set_permissions.sh ${HOME}/set_permissions.sh
COPY ./src/common/install/rdesktop1.6.0.tar.gz ${HOME}/rdesktop1.6.0.tar.gz 
RUN curl -L https://go.microsoft.com/fwlink/?LinkId=722418 -o /tmp/az_storage_explorer.tar.gz \
    && cd /tmp && mkdir -p ${HOME}/.az && tar xf az_storage_explorer.tar.gz -C ${HOME}/.az \
    && ln -s ${HOME}/.az/StorageExplorer /bin/azurestorageexplorer
    #&& mkdir ${HOME}/rdesktop && tar xf {HOME}/rdesktop1.6.0.tar.gz -C ${HOME}/rdesktop

### Update wetty
RUN cd /opt/wetty && sudo npm install

### Copy conf files
COPY ./src/caddyfile /Caddyfile
COPY ./src/services/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

### Make directories and files
RUN mkdir -p /var/run/sshd && touch /var/log/caddy.log && chown ubuntu:ubuntu /var/log/caddy.log

### Run everything
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
