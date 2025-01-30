#!/bin/bash

ip link add name ipvtap0 link wlp0s20f3 type ipvtap  mode l2 bridge
ip link set up ipvtap0
ip addr add 192.168.1.20/24 dev ipvtap0
