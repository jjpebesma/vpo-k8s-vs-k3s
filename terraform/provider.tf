terraform {
    required_providers {
        proxmox = {
            source  = "Telmate/proxmox"
            version = "3.0.1-rc2"
        }
    }
}

variable "pm_api_url" {
    type = string
}

variable "pm_api_token_id" {
    type = string
    sensitive = true
}

variable "pm_api_token_secret" {
    type = string
    sensitive = true
}

variable "ssh_keys" {
    type = string
    sensitive = true
}

variable "ciuser" {
    type = string
}

provider "proxmox" {
  # Configuration options
  pm_api_url = var.pm_api_url
  pm_api_token_id = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure = true
  pm_log_enable = true
  pm_log_file = "terraform-plugin-proxmox.log"
  pm_debug = true
  pm_log_levels = {
    _default = "debug"
    _capturelog = ""
  }
}
