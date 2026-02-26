locals {
  longhorn_chart_version = "1.7.2"
  longhorn_namespace     = "longhorn-system"
}

module "longhorn" {
  source = "github.com/gael-rozario/terraform-modules//k8s/longhorn"

  chart_version = local.longhorn_chart_version
  namespace     = local.longhorn_namespace
}

output "longhorn_namespace" {
  description = "Namespace where Longhorn is deployed"
  value       = module.longhorn.namespace
}

output "longhorn_chart_version" {
  description = "Deployed Longhorn chart version"
  value       = module.longhorn.chart_version
}
