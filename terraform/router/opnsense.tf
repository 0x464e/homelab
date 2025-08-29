resource "proxmox_vm_qemu" "opnsense" {
  name        = "OPNsense"
  target_node = "topton"
  vmid = 100

  bios = "ovmf"

  onboot = true

  startup = "order=1"

  vm_state = "running"

  protection = true

  boot = "order=scsi0;ide2;net0"

  agent = 1

  qemu_os = "l26"

  scsihw = "virtio-scsi-pci"

  memory = 8192

  skip_ipv6 = true

  cpu {
    cores = 4
    sockets = 1
    numa = false
    type = "host"
  }

  # WAN
  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
  }

  # AP-Switch Trunk
  network {
    id = 1
    model = "virtio"
    bridge = "vmbr1"
  }

  # Server
  network {
    id = 2
    model = "virtio"
    bridge = "vmbr2"
  }

  # Desktop PC
  network {
    id = 3
    model = "virtio"
    bridge = "vmbr3"
  }

  disks {
    ide {
      ide2 {
          cdrom {
            iso = "local:iso/OPNsense-25.7-dvd-amd64.iso"
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          cache       = "none"
          discard     = true
          emulatessd  = true
          iothread    = false
          size        = "64G"
          storage     = "local-zfs"
        }
      }
    }
  }

  efidisk {
    efitype = "4m"
    storage = "local-zfs"
    pre_enrolled_keys = false
  }
}
