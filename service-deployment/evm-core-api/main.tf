terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "evm-core-api-dev.tfstate"
    profile = "evm-dev"
  }
}

module "cloudflare" {
  source             = "../../modules/cloudflare"
  env                = var.env
  unit               = var.unit
  code               = var.code
  feature            = var.feature
  cloudflare_secrets = var.cloudflare_secrets
  zone_id            = var.cloudflare_secrets["zone_id"]
  type               = var.type
  ttl                = var.ttl
  proxied            = var.proxied
  allow_overwrite    = var.allow_overwrite
}

module "github" {
  source         = "../../modules/github"
  env            = var.env
  unit           = var.unit
  code           = var.code
  feature        = var.feature
  github_secrets = var.github_secrets
}


module "jenkins" {
  source            = "../../modules/jenkins"
  env               = var.env
  unit              = var.unit
  code              = var.code
  feature           = var.feature
  jenkins_secrets   = var.jenkins_secrets
  github_username   = var.github_secrets["owner"]
  github_repository = module.github.github_repository
  credentials_id    = var.credentials_id
}
