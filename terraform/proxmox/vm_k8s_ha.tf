# Kubernetes Master Nodes (3 for HA)
resource "proxmox_vm_qemu" "k8s_master" {
  count       = 3
  name        = "k8s-master${count.index + 1}-${local.cluster_suffix}"
  vmid        = local.master_ids[count.index]
  target_node = var.proxmox_node
  clone       = var.template_name
  ipconfig0   = "ip=${var.master_ips[count.index]}/24,gw=10.10.10.1"
  tags        = var.proxmox_tag

  # Master node resources
  cpu { cores = 4 }  
  memory  = 8192

  # Boot configuration
  boot  = "order=virtio0;ide2"
  agent = 1

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

  # Network configuration
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

  # Cloud-init configuration
  ciuser     = var.proxmox_ciuser
  cipassword = var.proxmox_cipassword
  sshkeys    = local.ssh_public_key

  nameserver = var.dns_servers

  lifecycle {
    ignore_changes = [
      network,
      cipassword,
    ]
  }
}

# Kubernetes Worker Nodes (4 for workload distribution)
resource "proxmox_vm_qemu" "k8s_worker" {
  count       = 4
  name        = "k8s-worker${count.index + 1}-${local.cluster_suffix}"
  vmid        = local.worker_ids[count.index]
  target_node = var.proxmox_node
  clone       = var.template_name
  tags        = var.proxmox_tag


  # Worker node resources
  cpu { cores = 4 }  
  memory     = 8192
  full_clone = true
  ipconfig10 = "ip=dhcp"
  scsihw     = "virtio-scsi-pci"
  os_type    = "cloudinit"
  ciuser     = var.proxmox_ciuser
  cipassword = var.proxmox_cipassword

  # Boot configuration
  boot  = "order=virtio0;ide2"
  agent = 1

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

  # Network configuration
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

  # Cloud-init configuration
  ipconfig0 = "ip=${var.worker_ips[count.index]}/24,gw=10.10.10.1"
  sshkeys   = local.ssh_public_key

  nameserver = var.dns_servers

  lifecycle {
    ignore_changes = [
      network,
      cipassword,
    ]
  }
}
