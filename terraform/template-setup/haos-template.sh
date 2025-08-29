#!/bin/bash

wget https://github.com/home-assistant/operating-system/releases/download/16.1/haos_ova-16.1.qcow2.xz
unxz haos_ova-16.1.qcow2.xz
qm create 9001 --name haos-template
qm set 9001 --scsi0 local-zfs:0,import-from=/root/haos_ova-16.1.qcow2
qm template 9001
rm haos_ova-16.1.qcow2

