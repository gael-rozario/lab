locals {
  metallb_chart_version   = "0.14.9"
  metallb_namespace       = "metallb-system"
  metallb_ip_address_pool = "192.168.0.240-192.168.0.250"

  longhorn_chart_version = "1.7.2"
  longhorn_namespace     = "longhorn-system"
}
