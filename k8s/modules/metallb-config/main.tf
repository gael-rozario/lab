locals {
  metallb_namespace       = "metallb-system"
  metallb_ip_address_pool = "192.168.0.240-192.168.0.250"
}

module "metallb_config" {
  source = "github.com/gael-rozario/terraform-modules//k8s/metallb-config"

  namespace       = local.metallb_namespace
  ip_address_pool = local.metallb_ip_address_pool
}

output "metallb_ip_address_pool" {
  description = "IP address range allocated to MetalLB"
  value       = module.metallb_config.ip_address_pool
}
