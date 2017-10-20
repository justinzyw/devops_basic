#!/bin/bash

# Fetch the variables
. parm.txt

# function to get the current time formatted
currentTime()
{
  date +"%Y-%m-%d %H:%M:%S";
}

#install NFS packages
echo ---$(currentTime)---Install NFS---

sudo apt-get -y install nfs-common nfs-kernel-server portmap

sudo service rpcbind start

# install nfs on one server only
# on server side
sudo mkdir /srv/nfs

wget https://raw.githubusercontent.com/justinzyw/devops_basic/master/exports

sudo cp exports /etc/exports

sudo /etc/init.d/nfs-kernel-server start 

sudo exportfs -a