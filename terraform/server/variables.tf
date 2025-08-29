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
  sensitive   = true
}

variable "proxmox_ssh_username" {
  description = "Proxmox SSH username"
  type        = string
}

variable "proxmox_ssh_password" {
  description = "Proxmox SSH password"
  type        = string
  sensitive   = true
}

variable "proxmox_ip" {
  description = "Proxmox server IP address"
  type        = string
}

variable "ssh_key" {
  type        = string
  description = "Public SSH key for access"
}

variable "docker_vm_hostname" {
  type        = string
  description = "Hostname of the Docker VM"
}
