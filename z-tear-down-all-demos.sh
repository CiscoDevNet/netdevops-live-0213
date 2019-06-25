#!/usr/bin/env bash

# NETDEVOPS LIVE S02E13 - TEARDOWN

# Pulls down all created interfaces and bridges.
for i in pair1-a pair1-b pair2-a pair2-b brtest1 brtest2 demobr1; do \
 sudo ip link set down ${i} ; \
done

# Delete interfaces
sudo ip link del pair1-a type veth peer name pair1-b
sudo ip link del pair2-a type veth peer name pair2-b
sudo ip link del brtest1
sudo ip link del brtest2
sudo brctl delbr demobr1

# Deletes docker containers
for c in container1 container2 container3; do \
 sudo docker kill ${c} ; sudo docker rm ${c} ; \
done
