#!/bin/bash

virsh --connect qemu:///system start Windows11
sleep 3
env -u WAYLAND_DISPLAY looking-glass-client -m 97 -F audio:micDefault=allow
