#!/bin/bash

virsh --connect qemu:///system create --file /etc/libvirt/qemu/Windows11.xml
sleep 3
env -u WAYLAND_DISPLAY looking-glass-client -m 97 -F audio:micDefault=allow
