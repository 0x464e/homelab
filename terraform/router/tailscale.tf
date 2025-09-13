resource "proxmox_lxc" "tailscale" {
  target_node  = "topton"
  hostname     = "tailscale"
  ostemplate   = "local:vztmpl/debian-13-standard_13.1-1_amd64.tar.zst"
  unprivileged = true
  start = true
  onboot = true
  protection = true
  startup = "order=5"

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

  network {
    name   = "eth0"
    bridge = "vmbr1"
    ip     = "192.168.10.9/24"
    ip6    = "manual"
    gw     = "192.168.10.1"
    tag    = 10
  }
}

# TODO:
# /etc/pve/lxc/<id>.conf needs these lines to enable TUN device
# lxc.cgroup2.devices.allow: c 10:200 rwm
# lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
# Reboot LXC after adding
