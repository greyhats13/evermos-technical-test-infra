terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "evm-toolchain-atlantis-dev.tfstate"
    profile = "evm-dev"
  }
}

module "helm" {
  source     = "../../modules/helm"
  region     = "sgp1"
  env        = "dev"
  unit       = "evm"
  code       = "toolchain"
  feature    = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  values     = []
  helm_sets = [
    {
      name  = "installCRDs"
      value = "true"
    },
    {
      name  = "controller.nodeSelector.service"
      value = "backend"
    }
  ]
}