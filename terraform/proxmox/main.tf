terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc09"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

provider "vault" {
  address = var.vault_address

  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = var.vault_role_id
      secret_id = var.vault_secret_id
    }
  }
}

data "vault_kv_secret_v2" "pm_api" {
  count = var.use_vault ? 1 : 0
  
  mount = var.vault_mount
  name  = var.vault_name
}

locals {
  token_id     = var.use_vault ? try(data.vault_kv_secret_v2.pm_api[0].data[var.vault_pm_api_token_id],     var.pm_api_token_id)     : var.pm_api_token_id
  token_secret = var.use_vault ? try(data.vault_kv_secret_v2.pm_api[0].data[var.vault_pm_api_token_secret], var.pm_api_token_secret) : var.pm_api_token_secret
  url          = var.use_vault ? try(data.vault_kv_secret_v2.pm_api[0].data[var.vault_pm_api_url],          var.pm_api_url)          : var.pm_api_url
  
  ssh_public_key = file(pathexpand(var.ssh_public_key_path))

  cluster_suffix = random_id.suffix.hex

  id_base = var.randomize_vmid ? random_integer.cluster_offset[0].result : var.vmid_base

  bastion_id = local.id_base + 1

  master_ids = [
    for i in range(var.master_count) :
    local.id_base + 2 + i
  ]

  worker_ids = [
    for i in range(var.worker_count) :
    local.id_base + 2 + var.master_count + i
  ]

  util_ids = [
    for i in range(var.util_count) :
    local.id_base + 2 + var.master_count + var.worker_count + i
  ]

}

resource "random_id" "suffix" {
  byte_length = 2
}

resource "random_integer" "cluster_offset" {
  count = var.randomize_vmid ? 1 : 0
  min   = 1000
  max   = 5000
}

variable "master_count" {
  type    = number
  default = 3

}
variable "worker_count" {
  type    = number
  default = 4
}

variable "util_count" {
  type    = number
  default = 8
}

provider "proxmox" {
  pm_api_token_id     = local.token_id
  pm_api_token_secret = local.token_secret
  pm_api_url          = local.url
  pm_tls_insecure     = true
  pm_minimum_permission_check = false
  pm_timeout          = 600 
      pm_log_enable = true
      pm_log_file   = "terraform-plugin-proxmox.log"
      pm_debug      = true
      pm_log_levels = {
        _default    = "debug"
        _capturelog = "terraform.log"
  }
}
