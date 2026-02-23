locals {
  metallb_chart_version   = "0.14.9"
  metallb_namespace       = "metallb-system"
  metallb_ip_address_pool = "192.168.0.240-192.168.0.250"
}

module "metallb" {
  source = "/home/gael/workspace/github.com/gael-rozario/terraform-modules/k8s/metallb"

  chart_version   = local.metallb_chart_version
  namespace       = local.metallb_namespace
  ip_address_pool = local.metallb_ip_address_pool
}

output "metallb_namespace" {
  description = "Namespace where MetalLB is deployed"
  value       = module.metallb.namespace
}

output "metallb_chart_version" {
  description = "Deployed MetalLB chart version"
  value       = module.metallb.chart_version
}

output "metallb_ip_address_pool" {
  description = "IP address range allocated to MetalLB"
  value       = module.metallb.ip_address_pool
}
