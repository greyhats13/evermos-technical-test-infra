terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "evm-toolchain-nginx.tfstate"
    profile = "evm-dev"
  }
}

module "helm" {
  source     = "../../modules/helm"
  region     = "sgp1"
  env        = "dev"
  unit       = "evm"
  code       = "toolchain"
  feature    = "nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  values     = []
  helm_sets = [
    {
      name  = "controller.replicaCount"
      value = 1
    },
    {
      name  = "controller.autoscaling.enabled"
      value = true
    },
    {
      name  = "controller.autoscaling.minReplicas"
      value = 1
    },
    {
      name  = "controller.autoscaling.maxReplicas"
      value = 2
    },
    {
      name  = "controller.nodeSelector.service"
      value = "backend"
    }
  ]
  override_namespace = "ingress"
  no_env             = true
}