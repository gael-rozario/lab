output "metallb_namespace" {
  description = "Namespace where MetalLB is deployed"
  value       = module.metallb.namespace
}

output "metallb_chart_version" {
  description = "Deployed MetalLB chart version"
  value       = module.metallb.chart_version
}

output "ip_address_pool" {
  description = "IP address range allocated to MetalLB"
  value       = module.metallb.ip_address_pool
}
