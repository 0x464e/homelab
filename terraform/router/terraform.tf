terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_endpoint
  pm_tls_insecure = true
  # token based auth commented out because root username&pass auth is mandatory for privileged operations..
  # pm_api_token_id = var.proxmox_api_token_id
  # pm_api_token_secret = var.proxmox_api_token
  pm_user = var.proxmox_username
  pm_password = var.proxmox_password

  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}
