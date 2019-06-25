#!/usr/bin/env bash

# NETDEVOPS LIVE S02E13 - Example 4
# Create some docker containers and investigate their network namespaces.

# Output current network namespaces via lsns.
echo "See lsns output below, before we create containers:"
sudo lsns --type=net
echo "------------------"
echo ""
echo "Press enter to create two containers..."
read

## Create two containers
### By default ubuntu containers run bash CLI, we dont want these interactive
### Hence the /bin/sleep and &
sudo docker run --name container1 ubuntu:latest /bin/sleep 1000000 &
sudo docker run --name container2 ubuntu:latest /bin/sleep 1000000 &
sleep 3

# Output current network namespaces via lsns.
echo "See lsns output below, notice the new namespaces for the two containers:"
sudo lsns --type=net
echo "------------------"
echo "Press enter to continue..."
read

## Install some cli tools (ip) into containers 1 and 2
## Obviously this wont survive if the container is stopped as it's not in the docker image.
sudo docker exec -ti container1 apt update
sudo docker exec -ti container1 apt install -y iproute2
sudo docker exec -ti container2 apt update
sudo docker exec -ti container2 apt install -y iproute2

echo "------------------"
echo "Press enter to run 'ip addr list' and 'ip route list' within the containers..."
read

echo "Container1:"
sudo docker exec -ti container1 ip addr list
sudo docker exec -ti container1 ip route list

echo "Container2:"
sudo docker exec -ti container2 ip addr list
sudo docker exec -ti container2 ip route list

echo "------------------"
echo "Notice there are none of the system interfaces or bridges we created."
echo "We can also use netns tools from the HOST to investigate and manipulate"
echo "Interfaces, routes, etc within a namespace."
echo ""
echo "Press enter to see the same info, for container1 via the nsenter tool"
read

# First we need the PID of the docker container we want to "enter" the namespace of.
# This is how the nsenter tool identifies which namespace we care about.
# This is the same pid as ps aux would show for the docker command.
export CONTAINER1_PID=$(sudo docker inspect -f '{{.State.Pid}}' container2)

# Prove this command above returns the same PID as we see for the container is ps aux
sudo ps aux | grep $CONTAINER1_PID

sudo nsenter -t ${CONTAINER1_PID} -n ip addr list
sudo nsenter -t ${CONTAINER1_PID} -n ip route list
