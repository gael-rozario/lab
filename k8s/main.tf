module "metallb" {
  source = "/home/gael/workspace/github.com/gael-rozario/terraform-modules/k8s/metallb"

  chart_version   = var.metallb_chart_version
  namespace       = var.metallb_namespace
  ip_address_pool = var.ip_address_pool
}
