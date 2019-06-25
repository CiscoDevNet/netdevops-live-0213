#!/usr/bin/env bash

# NETDEVOPS LIVE S02E13 - TEARDOWN
# Pulls down all created interfaces and bridges.

sudo ip link del pair1-a type veth peer name pair1-b
sudo ip link del pair2-a type veth peer name pair2-b
sudo ip link del brtest1
sudo ip link del brtest2
sudo brctl delbr demobr1
