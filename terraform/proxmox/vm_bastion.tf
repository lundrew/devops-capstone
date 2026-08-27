# Bastion as the Jump Host, has access to all VMs and serves as the ansible configurator for all VMs(where our github runner lives)
resource "proxmox_vm_qemu" "bastion" {
  name        = "bastion-${local.cluster_suffix}"
  vmid        = local.bastion_id
  target_node = var.proxmox_node
  clone       = var.template_name
  tags        = var.proxmox_tag

  cpu { cores = 2 }  
  memory  = 2048

  boot       = "order=virtio0;ide2"
  agent      = 1
  full_clone = true
  scsihw     = "virtio-scsi-pci"
  os_type    = "cloudinit"

  ciuser     = var.proxmox_ciuser
  cipassword = var.proxmox_cipassword
  sshkeys    = local.ssh_public_key


  # Disk Configuration
  disk {
    slot    = "virtio0"
    type    = "disk"
    storage = var.storage_pool
    size    = "20G"
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = var.storage_pool
    discard = true
  }

  network {
    id        = 0
    model     = "virtio"
    bridge    = var.network_bridge
    firewall  = false
    link_down = false
  }

  serial {
    id   = 0
    type = "socket"
  }

  vga {
    type = "serial0"
  }

  # DHCP configuration
  ipconfig0 = "ip=${var.bastion_ip}/24,gw=10.10.10.1"

  nameserver = var.dns_servers

  lifecycle {
    ignore_changes = [
      network,
      cipassword,
    ]
  }
}
