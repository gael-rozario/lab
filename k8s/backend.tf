terraform {
  backend "local" {
    path   = "/home/gael/workspace/github.com/gael-rozario/lab-tf-state/terraform/k8s/terraform.tfstate"
    backup = "/home/gael/workspace/github.com/gael-rozario/lab-tf-state/terraform/k8s/terraform.tfstate.backup"
  }
}
