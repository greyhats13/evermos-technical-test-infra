terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "evm-project-dev.tfstate"
    profile = "evm-dev"
  }
}

module "project" {
  source       = "../../modules/project"
  region       = "sgp1"
  env          = "dev"
  unit         = "evm"
  code         = "do"
  feature      = "infra"
  project_name = "Evermos"
  purpose      = "Service or API"
}
