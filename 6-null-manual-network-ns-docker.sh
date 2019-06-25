#!/usr/bin/env bash

# NETDEVOPS LIVE S02E13 - Example 6
# Show docker containers using the null networking options and manual networking.

# We can tell docker not to do any networking setup with --network=null.
echo ""
echo "Press enter to create a container with zero networking setup.."
read

### By default ubuntu containers run bash CLI, we dont want these interactive
### Hence the /bin/sleep and &
sudo docker run --name container4 --network=null ubuntu:latest /bin/sleep 1000000 &
sleep 3

# Output current network namespaces via lsns.
echo ""
echo "Notice below we now have FOUR containers but THREE network NS's"
echo ""
sudo docker ps
sudo lsns --type=net
echo "------------------"
echo "The new container has been given a networkNS, but with nothing configured in it!"
echo "We wont be able to install ip tools as there is no network connectivity!"
echo "Press enter to verify zero networking.."
read

## We dont have ping and dont have ip / ifconfig, and cant install them due to no internet.
## So we can use "nsenter" instead of docker exec into the container.
sudo docker exec -ti container4 cat /proc/net/route
sudo nsenter -t `sudo docker inspect -f '{{.State.Pid}}' container4` -n ifconfig


echo ""
echo "------------------"
echo "Press enter to create a new veth pair, and attach to the docker0 bridge"
read

sudo ip link add manual-a type veth peer name manual-b
sudo ip link set up manual-a
sudo ip link set up manual-b

# Add veth "manual-a" interfaces to docker0 bridge
sudo brctl addif docker0 manual-a
sudo brctl show docker0


echo ""
echo "------------------"
echo "Press enter to move manual-b into container4's netNS"
read

# The "ip set netns" command needs to see all the netns descriptors in /var/run/netns,
# by default docker moves them, symlink the one we care about so the tool works.

c4pid=$(sudo docker inspect -f '{{.State.Pid}}' container4)
sudo mkdir -p /var/run/netns/
sudo ln -sfT /proc/${c4pid}/ns/net /var/run/netns/container4

# Move the manual-b interface into the NETNS of container 4 and verify
sudo ip link set manual-b netns container4
sudo ip netns exec container4 ip addr list

echo ""
echo "------------------"
echo "Press enter to manually address the container's manual-b interface"
read

sudo ip netns exec container4 ip addr add 172.17.0.100/16 dev manual-b
sudo ip netns exec container4 ip route add default via 172.17.0.1

echo ""
echo "------------------"
echo "Press enter test connectivity by trying to install ping and then pinging 8.8.8.8"
echo ""
read

sudo docker exec -ti container4 echo "nameserver 8.8.8.8" > /etc/resolv.conf
sudo docker exec -ti container4 apt update
sudo docker exec -ti container4 apt install -y iproute2 iputils-ping
sudo docker exec -ti container4 ping -c 5 8.8.8.8
