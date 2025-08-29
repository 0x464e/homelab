variable "proxmox_api_endpoint" {
  description = "Proxmox API endpoint URL"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token secret"
  type        = string
}

variable "ssh_key" {
  type        = string
  description = "Public SSH key for access"
}

variable "proxmox_username" {
  type        = string
  description = "Proxmox username"
}

variable "proxmox_password" {
  type        = string
  description = "Proxmox password"
}
