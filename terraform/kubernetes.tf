resource "proxmox_vm_qemu" "k8s-server" {
    count = 3
    vmid = 111 + count.index
    name = "k8s-server-${1 + count.index}"
    target_node = "pve"
    clone = "alma-cloud"

    onboot = true
    agent = 1
    os_type = "cloud-init"

    cores = 2
    sockets = 1
    memory = 4096

    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    disks {
        scsi {
            scsi0 {
                disk {
                    size = 100
                    storage = "nvme0n1p1"
                }
            }
            scsi1 {
                cloudinit {
                    storage = "nvme0n1p1"
                }
            }
        }
    }

    scsihw   = "virtio-scsi-pci" 
    bootdisk = "scsi0"

    ipconfig0 = "ip=192.168.178.${11 + count.index}/24,gw=192.168.178.1"
    ciuser = var.ciuser
    sshkeys = var.ssh_keys
}

resource "proxmox_vm_qemu" "k8s-node" {
    count = 3
    vmid = 114 + count.index
    name = "k8s-node-${1 + count.index}"
    target_node = "pve"
    clone = "alma-cloud"

    onboot = true
    agent = 1
    os_type = "cloud-init"

    cores = 2
    sockets = 1
    memory = 8192

    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    disks {
        scsi {
            scsi0 {
                disk {
                    size = 250
                    storage = "nvme0n1p1"
                }
            }
            scsi1 {
                cloudinit {
                    storage = "nvme0n1p1"
                }
            }
        }
    }

    
    scsihw   = "virtio-scsi-pci" 
    bootdisk = "scsi0"

    ipconfig0 = "ip=192.168.178.${14 + count.index}/24,gw=192.168.178.1"
    ciuser = var.ciuser
    sshkeys = var.ssh_keys
}