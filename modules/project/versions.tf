terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    github = {
      source = "integrations/github"
    }
  }
  required_version = ">= 1.0"
}