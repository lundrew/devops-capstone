# Kubernetes Master Nodes
output "k8s_master_ips" {
  description = "Kubernetes Master Node IPs"
  value       = var.master_ips
}

# Kubernetes Worker Nodes
output "k8s_worker_ips" {
  description = "Kubernetes Worker Node IPs"
  value       = var.worker_ips
}

# Infrastructure Services
output "monitoring_ip" {
  description = "Monitoring (Prometheus + Grafana) IP"
  value       = var.monitoring_ip
}

# Complete Infrastructure Summary
output "infrastructure_summary" {
  description = "Complete infrastructure summary"
  value = {
    bastion       = var.bastion_ip
    k8s_masters   = var.master_ips
    k8s_workers   = var.worker_ips
    services = {
      monitoring = var.monitoring_ip
    }
  }
}
