resource "proxmox_lxc" "traefik" {
  target_node  = "topton"
  hostname     = "traefik"
  ostemplate   = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  unprivileged = true
  start = true
  onboot = true
  protection = true
  startup = "order=2"

  ssh_public_keys = var.ssh_key

  cores = 1
  memory = 512
  swap = 0

  nameserver = "1.1.1.1 8.8.8.8"

  rootfs {
    storage = "local-zfs"
    size    = "4G"
  }

  features {
    nesting = true
    keyctl  = true
  }

  mountpoint {
    key = "0"
    slot = 0

    mp = "/etc/traefik"
    volume = "/srv/traefik"

    size = "64M"
  }

  network {
    name   = "eth0"
    bridge = "vmbr1"
    ip     = "192.168.10.10/24"
    ip6    = "manual"
    gw     = "192.168.10.1"
    tag    = 10
  }
}
