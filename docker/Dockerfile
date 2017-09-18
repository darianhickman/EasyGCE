FROM ubuntu:16.04

RUN apt-get update && apt-get --assume-yes upgrade

RUN apt-get --assume-yes install git wget

RUN grep ubuntu /etc/passwd || useradd -m ubuntu

RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    && sudo apt-get update \
    && sudo apt-get install --assume-yes google-cloud-sdk

RUN apt-get --assume-yes install python-pip \
    && pip install awscli --upgrade --user

RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" > /etc/apt/sources.list.d/azure-cli.list \
    && apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893 \
    && apt-get --assume-yes install apt-transport-https \
    && apt-get update \
    && apt-get --assume-yes install azure-cli

RUN apt-get --assume-yes install xfce4

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get --assume-yes install google-chrome-stable

RUN apt-get --assume-yes install xrdp

RUN apt-get --assume-yes install tightvncserver

RUN apt-get --assume-yes install openssh-server

#RUN echo -e "deb http://nginx.org/packages/ubuntu/ xenial nginx\ndeb-src http://nginx.org/packages/ubuntu/ xenial nginx" > \
#    /etc/apt/sources.list.d/nginx.list \
#    && apt-get update \
#    && apt-get --allow-unauthenticated --assume-yes install nginx \
#    && > /etc/nginx/conf.d/default.conf \
#    && > /etc/nginx/sites-enabled/default

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \
    && apt-get install --assume-yes nodejs \
    && apt-get install --assume-yes npm \
    && mkdir -p /opt/wetty \
    && git clone https://github.com/krishnasrinivas/wetty /opt/wetty

RUN curl https://getcaddy.com | bash -s personal http.forwardproxy,http.realip,net

RUN apt-get --assume-yes install filezilla

ENV LANG en_US.UTF-8
ENV TERM xterm

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
