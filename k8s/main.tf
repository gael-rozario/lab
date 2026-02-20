module "metallb" {
  source = "/home/gael/workspace/github.com/gael-rozario/terraform-modules/k8s/metallb"

  chart_version   = local.metallb_chart_version
  namespace       = local.metallb_namespace
  ip_address_pool = local.metallb_ip_address_pool
}
