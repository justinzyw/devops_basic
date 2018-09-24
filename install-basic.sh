#!/bin/bash

# Fetch the variables
. parm.txt

# function to get the current time formatted
currentTime()
{
  date +"%Y-%m-%d %H:%M:%S";
}

echo ---$(currentTime)---Install Docker---

#increase the memnory use of VMs, specifically as required by Elasticsearch
echo "vm.max_map_count=262144" | sudo tee --append /etc/sysctl.conf

# install docker ce
sudo apt update

sudo apt-get -y install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual \
    apt-transport-https \
    ca-certificates \
    curl \
	wget \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
sudo apt update

sudo apt-get -y install docker-ce

# no need to sudo for docker commands
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod a+rw /var/run/docker.sock


echo ---$(currentTime)---setup docker---

wget https://raw.githubusercontent.com/justinzyw/devops_basic/master/daemon.json
sudo cp daemon.json  /etc/docker/daemon.json

#it is possble that the dockerhub is too slow in China. add Aliyun proxy: "registry-mirrors": ["https://xxxxxxxxx.mirror.aliyuncs.com"]

#It is possible that after updating the daemon.json file, restart fails. Then need to create file /etc/systemd/system/docker.service.d/docker.conf by removing "-H fd://" and setting the ExecStart line to ExecStart=/usr/bin/dockerd. Refer to https://docs.docker.com/config/daemon/#troubleshoot-conflicts-between-the-daemonjson-and-startup-scripts
wget https://raw.githubusercontent.com/justinzyw/devops_basic/master/docker.conf
sudo mkdir /etc/systemd/system/docker.service.d
sudo cp docker.conf  /etc/systemd/system/docker.service.d/docker.conf

sudo systemctl daemon-reload

sudo systemctl restart docker

#install local-persist volume plugin
curl -fsSL https://raw.githubusercontent.com/CWSpear/local-persist/master/scripts/install.sh | sudo bash


#install NFS packages
echo ---$(currentTime)---Install NFS---

sudo apt-get -y install nfs-common nfs-kernel-server portmap

sudo service rpcbind start

#on client side, remember to change ip accordingly

sudo mkdir /var/nfs/

sudo mkdir /var/nfs/volumes/

sudo mount -t nfs $NFS_HOST_IP:/srv/nfs /var/nfs/volumes

echo "$NFS_HOST_IP:/srv/nfs/ /var/nfs/volumes/ nfs rw,defaults 0 0" | sudo tee -a /etc/fstab



