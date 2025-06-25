#!/bin/bash

pkexec sh -c "sudo rmmod nvidia_drm nvidia_modeset nvidia_uvm nvidia && sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1 && sudo virsh nodedev-detach pci_0000_01_00_0"
virsh --connect qemu:///system start Windows11-Nvidia
sleep 3
env -u WAYLAND_DISPLAY looking-glass-client -m 97 -F audio:micDefault=allow
