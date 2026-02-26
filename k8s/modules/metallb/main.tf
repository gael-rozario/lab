locals {
  metallb_chart_version = "0.14.9"
  metallb_namespace     = "metallb-system"
}

module "metallb" {
  source = "github.com/gael-rozario/terraform-modules//k8s/metallb"

  chart_version = local.metallb_chart_version
  namespace     = local.metallb_namespace
}

output "metallb_namespace" {
  description = "Namespace where MetalLB is deployed"
  value       = module.metallb.namespace
}

output "metallb_chart_version" {
  description = "Deployed MetalLB chart version"
  value       = module.metallb.chart_version
}
