#!/usr/bin/env bash

# NETDEVOPS LIVE S02E13 - Example 1
# Create a new bridge and add two dummy interfaces to it.

## Two dummy interfaces "unnumbered" and up.
sudo ip link add brtest1 type dummy
sudo ip link add brtest2 type dummy
sudo ip link set up brtest1
sudo ip link set up brtest2

# New bridge, up
sudo brctl addbr demobr1
sudo ip link set up demobr1

# Give bridge a L3 interface
sudo ip addr add 172.16.0.1/24 dev brtest1

# Add dummy interfaces to bridge and output.
sudo brctl addif demobr1 brtest1 brtest2
sudo brctl show demobr1
sudo brctl showmacs demobr1
