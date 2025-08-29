#!/bin/bash

wget https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2
qm create 9002 --name debian13-cloudinit
qm set 9002 --scsi0 local-zfs:0,import-from=/root/debian-13-genericcloud-amd64.qcow2
qm template 9002
rm debian-13-genericcloud-amd64.qcow2
