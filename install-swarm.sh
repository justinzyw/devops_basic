#!/bin/bash

# Fetch the variables
. parm.txt

# function to get the current time formatted
currentTime()
{
  date +"%Y-%m-%d %H:%M:%S";
}

echo ---$(currentTime)---setup overlay network---
sudo docker network create \
--driver overlay \
--subnet $HOST_INTERNAL_SUBNET \
--gateway $HOST_INTERNAL_IP \
--attachable \
devops_network

echo ---$(currentTime)---initiate swarm---
sudo docker swarm init --advertise-addr $LEAD_HOST_IP



sudo docker swarm join-token manager
#其他manager节点加入，用sudo docker swarm join-token manager来获取加入集群的命令

#如果由于managernode ip改变或其他原因导致集群失效，可以利用sudo docker swarm init --force-new-cluster来重置整个集群
