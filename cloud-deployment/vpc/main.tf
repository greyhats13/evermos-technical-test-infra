terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "evm-vpc-network-dev.tfstate"
    profile = "evm-dev"
  }
}

module "vpc" {
  source   = "../../modules/vpc"
  region   = "sgp1"
  env      = "dev"
  unit     = "evm"
  code     = "vpc"
  feature  = "network"
  ip_range = "10.0.0.0/16"
}
