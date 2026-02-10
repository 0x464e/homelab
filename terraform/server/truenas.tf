resource "proxmox_vm_qemu" "truenas" {
  name = "TrueNAS"
  target_node = "pve"
  vmid = 100

  bios = "ovmf"
  vm_state = "started"
  start_at_node_boot = true
  protection = true
  boot = "order=scsi0;ide2;net0"
  agent = 1
  machine = "q35"
  qemu_os = "l26"
  scsihw = "virtio-scsi-pci"
  memory = 24576
  balloon = 24576
  skip_ipv6 = true


  startup_shutdown {
    order = 1
    startup_delay = 90
  }

  cpu {
    cores = 2
    sockets = 1
    numa = false
    type = "host"
  }

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
  }

  pcis {
    pci0 {
      mapping {
        mapping_id = "LSI-HBA"
        pcie = true
        rombar = false
      }
    }
  }

  disks {
    ide {
      ide2 {
          cdrom {
            iso = "local:iso/TrueNAS-SCALE-25.04.1.iso"
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
          size        = "32G"
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
