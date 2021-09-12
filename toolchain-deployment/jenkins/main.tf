terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "evm-toolchain-jenkins-dev.tfstate"
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

# data "template_file" "helm_values" {
#   template = file("values.yaml")

#   vars = {
#     unit           = var.unit
#     code           = var.code
#     feature        = var.feature
#     env            = var.env
#     storage_size   = var.storage_size
#     admin_user     = var.jenkins_secrets["admin_username"]
#     admin_password = var.jenkins_secrets["admin_password"]
#     ingress_class = var.env == "dev" ? "alpha" : (
#       var.env == "stg" ? "beta" : "evermos"
#     )
#     jenkins_hostname = module.cloudflare.cloudflare_hostname
#   }
# }

module "helm" {
  source     = "../../modules/helm"
  region     = var.region
  env        = var.env
  unit       = var.unit
  code       = var.code
  feature    = var.feature
  repository = var.repository
  chart      = var.chart
  values     = [file("values.yaml")]
  helm_sets  = []
}
