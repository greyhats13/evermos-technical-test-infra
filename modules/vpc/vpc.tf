resource "digitalocean_vpc" "vpc" {
  name     = "${var.unit}-${var.code}-${var.feature}-${var.env}"
  region   = var.region
  ip_range = var.ip_range
}