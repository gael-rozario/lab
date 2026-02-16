variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = ""
}

variable "metallb_chart_version" {
  description = "MetalLB Helm chart version"
  type        = string
  default     = "0.14.9"
}

variable "metallb_namespace" {
  description = "Namespace to deploy MetalLB into"
  type        = string
  default     = "metallb-system"
}

variable "ip_address_pool" {
  description = "IP address range for MetalLB to allocate (e.g. 192.168.56.200-192.168.56.250)"
  type        = string
}
