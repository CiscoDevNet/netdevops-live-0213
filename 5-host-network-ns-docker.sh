#!/usr/bin/env bash

# NETDEVOPS LIVE S02E13 - Example 5
# Show docker containers using the host networking options.

# We can tell docker not to create a networkns with --network=host.
echo ""
echo "Press enter to create a container using the host's default namespace..."
read

## Create a container with host network namespace.
### By default ubuntu containers run bash CLI, we dont want these interactive
### Hence the /bin/sleep and &
sudo docker run --name container3 --network=host ubuntu:latest /bin/sleep 1000000 &
sleep 3

# Output current network namespaces via lsns.
echo "Notice below we now have THREE containers but only TWO network NS's"
sudo docker ps
sudo lsns --type=net
echo "------------------"
echo "Press enter to install ip tools CLI into container3..."
read

## Install some cli tools (ip) into containers 1 and 2
## Obviously this wont survive if the container is stopped as it's not in the docker image.
sudo docker exec -ti container3 apt update
sudo docker exec -ti container3 apt install -y iproute2 iputils-ping


echo "------------------"
echo "Press enter to run 'ip addr list' and 'ip route list' within the containers..."
read

echo "Container3:"
sudo docker exec -ti container3 ip addr list
sudo docker exec -ti container3 ip route list

echo "------------------"
echo "Press enter to run ping 8.8.8.8 from the container"
read

sudo docker exec -ti container3 ping -c 5 8.8.8.8
