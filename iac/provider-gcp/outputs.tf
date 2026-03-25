output "static_ip_address" {
  description = "The reserved static IP address for outbound connections from your PC"
  value       = module.cluster.static_ip_address
}

output "open_ports" {
  description = "Ports open for inbound connections to GCP resources"
  value       = module.cluster.open_ports
}

output "connection_map" {
  description = "Ready-to-use host:port pairs for each service"
  value       = module.cluster.connection_map
}
