provider "cloudflare" {
  email   = var.cloudflare_secrets["email"]
  api_key = var.cloudflare_secrets["api"]
}

data "terraform_remote_state" "nginx" {
  backend = "s3"
  config = {
    bucket  = "greyhats13-tfstate"
    key     = "${var.unit}-toolchain-nginx.tfstate"
    region  = "ap-southeast-1"
    profile = "${var.unit}-${var.env}"
  }
}

resource "cloudflare_record" "record" {
  zone_id         = var.zone_id
  name            = var.code != "toolchain" ? "${var.feature}.${var.code}.${var.env}":"${var.feature}.${var.code}"
  value           = data.terraform_remote_state.nginx.outputs.do_helm_nginx_loadbalancer_ip
  type            = var.type
  ttl             = var.ttl
  proxied         = var.proxied
  allow_overwrite = var.allow_overwrite
}

resource "cloudflare_record" "staging" {
  count           = var.code != "toolchain" ? 1:0
  zone_id         = var.zone_id
  name            = "${var.feature}.${var.code}.${var.env}"
  value           = data.terraform_remote_state.nginx.outputs.do_helm_nginx_loadbalancer_ip
  type            = var.type
  ttl             = var.ttl
  proxied         = var.proxied
  allow_overwrite = var.allow_overwrite
}

resource "cloudflare_record" "production" {
  count           = var.code != "toolchain" ? 1:0
  zone_id         = var.zone_id
  name            = "${var.feature}.${var.code}.${var.env}"
  value           = data.terraform_remote_state.nginx.outputs.do_helm_nginx_loadbalancer_ip
  type            = var.type
  ttl             = var.ttl
  proxied         = var.proxied
  allow_overwrite = var.allow_overwrite
}