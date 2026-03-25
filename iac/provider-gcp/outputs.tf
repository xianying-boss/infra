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

output "jumphost_ip" {
  description = "Static IP of the jumphost VM"
  value       = var.jumphost_ip
}

output "ssh_command" {
  description = "Basic SSH command to connect to the jumphost from your PC"
  value       = "ssh -i ~/.ssh/id_rsa user@${var.jumphost_ip} # replace 'user' with your GCP username"
}

output "jumphost_proxy_commands" {
  description = "SSH tunnel commands — run each from your PC to forward GCP service ports locally through the jumphost"
  value = {
    https         = "ssh -i ~/.ssh/id_rsa -L 8443:localhost:443  -N user@${var.jumphost_ip} # replace 'user' with your GCP username"
    http          = "ssh -i ~/.ssh/id_rsa -L 8080:localhost:80   -N user@${var.jumphost_ip} # replace 'user' with your GCP username"
    ssh_tunnel    = "ssh -i ~/.ssh/id_rsa -L 2222:localhost:22   -N user@${var.jumphost_ip} # replace 'user' with your GCP username"
    session_proxy = "ssh -i ~/.ssh/id_rsa -L 3002:localhost:3002 -N user@${var.jumphost_ip} # replace 'user' with your GCP username"
    docker        = "ssh -i ~/.ssh/id_rsa -L 5000:localhost:5000 -N user@${var.jumphost_ip} # replace 'user' with your GCP username"
    ingress       = "ssh -i ~/.ssh/id_rsa -L 8800:localhost:8800 -N user@${var.jumphost_ip} # replace 'user' with your GCP username"
    nomad_ui      = "ssh -i ~/.ssh/id_rsa -L 4646:localhost:4646 -N user@${var.jumphost_ip} # replace 'user' with your GCP username"
  }
}

output "jumphost_all_tunnels" {
  description = "Single command to open ALL tunnels at once through the jumphost"
  value       = "ssh -i ~/.ssh/id_rsa -L 8443:localhost:443 -L 8080:localhost:80 -L 3002:localhost:3002 -L 5000:localhost:5000 -L 8800:localhost:8800 -L 4646:localhost:4646 -N user@${var.jumphost_ip} # replace 'user' with your GCP username"
}
