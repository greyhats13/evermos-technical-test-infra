terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "evm-toolchain-metrics-server-dev.tfstate"
    profile = "evm-dev"
  }
}

module "helm" {
  source             = "../../modules/helm"
  region             = "sgp1"
  env                = "dev"
  unit               = "evm"
  code               = "toolchain"
  feature            = "metrics-server"
  repository         = "https://kubernetes-sigs.github.io/metrics-server/"
  chart              = "metrics-server"
  values             = []
  helm_sets          = []
  override_namespace = "kube-system"
  no_env             = true
}
