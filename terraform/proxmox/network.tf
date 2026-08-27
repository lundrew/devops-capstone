# Network Configuration (Optional)
# This file is for advanced network configuration like VLANs and firewall rules
# For basic DHCP setup, this file can be minimal or empty

# Note: Basic networking is already configured in each VM definition
# All VMs are set to use DHCP and connect to the bridge defined in variables

# If you want to add VLANs or firewall rules later, you can add them here
# For now, this file can remain empty as networking is handled per-VM

# Example VLAN configuration (commented out - enable if needed):
# resource "proxmox_vm_qemu" "example" {
#   network {
#     model  = "virtio"
#     bridge = var.network_bridge
#     tag    = 100  # VLAN tag
#   }
# }

# Example: If you want to document your network setup
locals {
  network_config = {
    bridge       = var.network_bridge
    dhcp_enabled = true
    dns_servers  = var.dns_servers
    description  = "All VMs use DHCP from the router/DHCP server"
  }
}

# You can add firewall rules here if needed in the future
# For basic setup, Proxmox firewall or router handles this
