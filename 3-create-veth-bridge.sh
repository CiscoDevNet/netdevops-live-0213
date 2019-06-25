#!/usr/bin/env bash

# NETDEVOPS LIVE S02E13 - Example 3
# Create a bridge with vETH's and prove traffic gets to the bridge
# from the other "end" of the vETH.

## Create two vETH pairs
sudo ip link add pair1-a type veth peer name pair1-b
sudo ip link add pair2-a type veth peer name pair2-b
sudo ip link set up pair1-a
sudo ip link set up pair1-b
sudo ip link set up pair2-a
sudo ip link set up pair2-b

# Add veth "side-a" interfaces to bridge.
sudo brctl addif demobr1 pair1-a pair2-a

# Give side B's of the veth's IP addresses (Bridge has 172.16.0.1/24)
sudo ip addr add 172.16.0.2/24 dev pair1-b
sudo ip addr add 172.16.0.3/24 dev pair1-b

# Show commands
sudo brctl show demobr1
sudo brctl showmacs demobr1
