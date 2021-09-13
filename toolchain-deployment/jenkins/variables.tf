#Naming Standard
variable "unit" {
  default = "evm"
}

variable "env" {
  default = "dev"
}

variable "code" {
  default = "toolchain"
}

variable "feature" {
  default = "jenkins"
}

variable "region" {
  default = "sgp1"
}

#cloudflare
variable "type" {
  default = "A"
}

variable "ttl" {
  default = 1
}

variable "proxied" {
  default = false
}

variable "allow_overwrite" {
  default = true
}

variable "cloudflare_secrets" {
  #Cloudflare secrets and the value is assigned on tfvars
}

#helm
variable "storage_size" {
  default = "5Gi"
}

variable "jenkins_secrets" {
  #Jenkins secrets and the value is assigned on tfvars
  sensitive = true
}

variable "github_secrets" {
  #Jenkins secrets and the value is assigned on tfvars
  sensitive = true
}

variable "docker_secrets" {
  #Jenkins secrets and the value is assigned on tfvars
  sensitive = true
}

variable "repository" {
  default = "https://charts.jenkins.io"
}

variable "chart" {
  default = "jenkins"
}