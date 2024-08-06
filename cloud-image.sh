#!/bin/bash

wget https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2

sleep 2
qm create 8000 --memory 2048 --core 2 --name alma-cloud --net0 virtio,bridge=vmbr0

sleep 2
qm disk import 8000 AlmaLinux-9-GenericCloud-latest.x86_64.qcow2 nvme0n1p1

sleep 2
qm set 8000 --scsihw virtio-scsi-pci --scsi0 nvme0n1p1:8000/vm-8000-disk-0.raw

sleep 2
qm set 8000 --ide2 nvme0n1p1:cloudinit

sleep 2
qm set 8000 --boot c --bootdisk scsi0

sleep 2
qm set 8000 --serial0 socket --vga serial0

sleep 2
qm template 8000
