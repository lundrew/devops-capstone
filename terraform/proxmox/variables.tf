# ==========================================
# Proxmox Configuration
# ==========================================

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Skip TLS certificate verification for the Proxmox API (useful with self-signed certs)"
  default     = false
}

variable "randomize_vmid" {
  type        = bool
  description = "Starting VMID will randomize between 1000-5000 when = true"
}

variable "vmid_base" {
  type        = number
  description = "Starting VMID when randomize_vmid = false"
  default     = 200
}

variable "proxmox_tag" {
  type = string
  default = null
}

variable "storage_pool" {
  description = "Storage pool for VM disks"
  type        = string
}

variable "template_name" {
  description = "VMID of the Proxmox VM template to clone"
  type        = string
}

# Password
variable "proxmox_ciuser" {
  type      = string
  sensitive = true
}

# Password
variable "proxmox_cipassword" {
  type      = string
  sensitive = true
}

# API
variable "pm_api_token_id" {
  type = string 
  sensitive = true
  default = null
}

variable "pm_api_token_secret" {
  type = string 
  sensitive = true
  default = null

}

variable "pm_api_url" {
  type = string 
  sensitive = true
  default = null
}

# ==========================================
# Vaults
# ==========================================

variable "use_vault" {
  type        = bool
  description = "Set to false when running on the Proxmox host without Vault access"
  default     = true
}

variable "vault_address" {
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "vault_mount" {
  type        = string
  default     = "terraform"
}

variable "vault_name" {
  type        = string
  default     = "proxmox"
}

variable "vault_role_id" {
  sensitive = true
  default = null
}

variable "vault_secret_id" {
  sensitive = true
  default = null
}

variable "vault_pm_api_token_id" {
  type = string 
  sensitive = true
  default = null
}

variable "vault_pm_api_token_secret" {
  type = string 
  sensitive = true
  default = null

}

variable "vault_pm_api_url" {
  type = string 
  sensitive = true
  default = null
}

# ==========================================
# Network Configuration
# ==========================================

# IPs
variable "bastion_ip" {
  type = string
}
variable "master_ips" {
  type    = list(string)
}

variable "worker_ips" {
  type    = list(string)
}

variable "monitoring_ip" {
  type = string
}

# Network
variable "network_bridge" {
  description = "Network bridge to use"
  type        = string
}

variable "dns_servers" {
  description = "DNS servers"
  type        = string
}

# ==========================================
# Ansible Connection
# ==========================================

variable "ansible_user" {
  type        = string
  description = "SSH user Ansible will connect as"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used for VM access"
  type        = string
  default     = "keys/ansible_ed25519.pub"
}