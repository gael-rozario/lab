module "longhorn" {
  source = "./modules/longhorn"
}

module "metallb" {
  source = "./modules/metallb/"
}

module "metallb_config" {
  source = "./modules/metallb-config/"
}

output "longhorn_namespace" {
  description = "Namespace where Longhorn is deployed"
  value       = module.longhorn.longhorn_namespace
}

output "longhorn_chart_version" {
  description = "Deployed Longhorn chart version"
  value       = module.longhorn.longhorn_chart_version
}
