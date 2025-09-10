resource "proxmox_lxc" "cloudflared" {
  target_node  = "topton"
  hostname     = "cloudflared"
  ostemplate   = "local:vztmpl/debian-13-standard_13.1-1_amd64.tar.zst"
  unprivileged = true
  start = true
  onboot = true
  protection = true
  startup = "order=4"

  ssh_public_keys = var.ssh_key

  cores = 1
  memory = 512
  swap = 0

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

    mp = "/etc/cloudflared"
    volume = "/srv/cloudflared"

    size = "64M"
  }

  network {
    name   = "eth0"
    bridge = "vmbr1"
    ip     = "192.168.10.11/24"
    ip6    = "manual"
    gw     = "192.168.10.1"
    tag    = 10
  }
}
