output "shared_chunk_cache_path" {
  value = var.filestore_cache_enabled ? "${local.nfs_mount_path}/${local.nfs_mount_subdir}" : ""
}

output "static_ip_address" {
  description = "The reserved static IP address for outbound connections from your PC"
  value       = module.network.e2b_static_ip_address
}

output "open_ports" {
  description = "Ports open for inbound connections to GCP resources"
  value = {
    https         = 443
    http          = 80
    ssh           = 22
    session_proxy = 3002
    docker        = 5000
    ingress       = 8800
  }
}

output "connection_map" {
  description = "Ready-to-use host:port pairs for each service"
  value = {
    https         = "${module.network.e2b_static_ip_address}:443"
    http          = "${module.network.e2b_static_ip_address}:80"
    ssh           = "${module.network.e2b_static_ip_address}:22"
    session_proxy = "${module.network.e2b_static_ip_address}:3002"
    docker        = "${module.network.e2b_static_ip_address}:5000"
    ingress       = "${module.network.e2b_static_ip_address}:8800"
  }
}
