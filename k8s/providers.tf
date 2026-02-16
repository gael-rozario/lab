provider "helm" {
  kubernetes {
    config_context = var.kubeconfig_context != "" ? var.kubeconfig_context : null
  }
}

provider "kubernetes" {
  config_context = var.kubeconfig_context != "" ? var.kubeconfig_context : null
}
