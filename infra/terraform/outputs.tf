output "control_plane_public_ip" {
  description = "Public IP of the k3s control plane node"
  value       = module.compute.control_plane_public_ip
}

output "worker1_public_ip" {
  description = "Public IP of worker node 1"
  value       = module.compute.worker1_public_ip
}

output "worker2_public_ip" {
  description = "Public IP of worker node 2"
  value       = module.compute.worker2_public_ip
}

output "control_plane_private_ip" {
  description = "Private IP of the k3s control plane node"
  value       = module.compute.control_plane_private_ip
}
