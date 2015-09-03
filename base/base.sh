#!/bin/bash

sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list

apt-get update
apt-get -y upgrade

apt-get install -y vim openssh-server wget zip unzip software-properties-common debconf-utils curl python-setuptools 

# supervisor
easy_install supervisor==3.1.3
mkdir /etc/supervisor.d/
mkdir -m 744 -p /var/log/supervisor

# supervisord.conf
cat << _EOT_ > /etc/supervisord.conf
[supervisord]
nodaemon=true
logfile=/var/log/supervisor/supervisord.log
 
[inet_http_server]
port=127.0.0.1:9001
 
[supervisorctl]
serverurl=http://127.0.0.1:9001
 
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
 
[include]
files = /etc/supervisor.d/*.conf
_EOT_

# base.conf
cat << _EOT_ > /etc/supervisor.d/base.conf
[program:sshd]
command=/usr/sbin/sshd -D
redirect_stderr=true
stdout_logfile=/var/log/supervisor/sshd.log
_EOT_


# ssh
mkdir /var/run/sshd
useradd -m -p password -s /bin/bash ubuntu
gpasswd -a ubuntu ubuntu 
mkdir -p /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
cp /docker_build/base/id_rsa.pub /home/ubuntu/.ssh/authorized_keys 
chmod 600 /home/ubuntu/.ssh/authorized_keys
chown -Rf ubuntu.ubuntu /home/ubuntu

# sudo
echo "ubuntu ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu
