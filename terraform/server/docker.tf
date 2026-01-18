resource "proxmox_vm_qemu" "docker" {
  depends_on = [null_resource.upload_cloudinit_snippet]

  name        = "Docker"
  target_node = "pve"
  vmid        = 101

  clone = "debian13-cloudinit"

  bios    = "ovmf"
  vm_state = "started"
  protection = true
  boot    = "order=scsi0"
  agent   = 1
  machine = "q35"
  qemu_os = "l26"
  scsihw  = "virtio-scsi-pci"
  memory  = 24576
  balloon = 8192
  skip_ipv6 = true


  nameserver = "192.168.10.1"
  ipconfig0  = "ip=192.168.10.6/24,gw=192.168.10.1"
  cicustom   = "user=local:snippets/${var.docker_vm_hostname}-cloudinit.yaml"

  startup_shutdown {
    order = 2
    startup_delay = 30
  }

  cpu {
    cores   = 12
    sockets = 1
    numa    = false
    type    = "host"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }


  pcis {
    pci0 {
      mapping {
        mapping_id  = "RTX-2070S"
        pcie        = true
        rombar      = false
        primary_gpu = true
      }
    }
  }

  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        disk {
          cache      = "none"
          discard    = true
          emulatessd = true
          iothread   = false
          size       = "256G"
          storage    = "local-zfs"
        }
      }
      scsi1 {
        cloudinit {
          storage = "local-zfs"
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

resource "local_file" "cloudinit_snippet" {
  content = templatefile("${path.module}/templates/docker-cloudinit.tftpl", {
    hostname = var.docker_vm_hostname
    ssh_key  = var.ssh_key
  })
  filename = "${path.module}/build/${var.docker_vm_hostname}-cloudinit.yaml"
}

resource "null_resource" "upload_cloudinit_snippet" {
  depends_on = [local_file.cloudinit_snippet]

  triggers = {
    content_hash = sha256(local_file.cloudinit_snippet.content)
  }

  connection {
    type     = "ssh"
    host     = var.proxmox_ip
    user     = var.proxmox_ssh_username
    password = var.proxmox_ssh_password
  }

  provisioner "file" {
    source      = local_file.cloudinit_snippet.filename
    destination = "/var/lib/vz/snippets/${var.docker_vm_hostname}-cloudinit.yaml"
  }
}
