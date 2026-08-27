resource "proxmox_vm_qemu" "monitoring" {
  count       = 1
  name        = "monitoring-${local.cluster_suffix}"
  vmid        = local.util_ids[0]
  target_node = var.proxmox_node
  clone       = var.template_name

  tags = var.proxmox_tag

  cpu {
    cores = 2
  }

  memory = 4096

  agent      = 1
  full_clone = true
  os_type    = "cloudinit"

  scsihw = "virtio-scsi-pci"
  boot = "order=virtio0;ide2"

  ciuser     = var.proxmox_ciuser
  cipassword = var.proxmox_cipassword

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

  ipconfig0 = "ip=${var.monitoring_ip}/24,gw=10.10.10.1"

  sshkeys    = local.ssh_public_key
  nameserver = var.dns_servers

  lifecycle {
    ignore_changes = [
      network,
      cipassword,
    ]
  }
}