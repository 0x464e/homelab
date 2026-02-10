resource "proxmox_vm_qemu" "home-assistant" {
  name        = "Home-Assistant"
  target_node = "pve"
  vmid        = 102

  clone = "haos-template"

  bios    = "ovmf"
  vm_state = "started"
  start_at_node_boot = true
  protection = true
  boot    = "order=scsi0"
  agent   = 1
  machine = "q35"
  qemu_os = "l26"
  scsihw  = "virtio-scsi-pci"
  memory  = 4096
  balloon = 4096
  skip_ipv6 = true


  startup_shutdown {
    order = 3
  }

  cpu {
    cores   = 2
    sockets = 1
    numa    = false
    type    = "host"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  serial {
    id   = 0
  }

  disks {
    scsi {
      scsi0 {
        disk {
          cache      = "none"
          discard    = true
          emulatessd = true
          iothread   = false
          size       = "64G"
          storage    = "local-zfs"
        }
      }
    }
  }

  efidisk {
    efitype           = "4m"
    storage           = "local-zfs"
    pre_enrolled_keys = false
  }
}
