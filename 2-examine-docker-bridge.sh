#!/usr/bin/env bash

# NETDEVOPS LIVE S02E13 - Example 2
# Examine the existing docker bridge and interfaces

sudo brctl show
sudo brctl showmacs docker0
sudo ip route list
