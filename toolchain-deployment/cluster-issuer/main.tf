terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "evm-toolchain-cluster-issuer-dev.tfstate"
    profile = "evm-dev"
  }
}

module "k8s" {
  source   = "../../modules/k8s"
  region   = "sgp1"
  env      = "dev"
  unit     = "evm"
  code     = "toolchain"
  feature  = "cluster-issuer"
  manifest = file("cluster-issuer.yaml")
}
