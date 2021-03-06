#Naming Standard
variable "unit" {
  default = "evm"
}

variable "env" {
  default = "dev"
}

variable "code" {
  default = "core"
}

variable "feature" {
  default = "test"
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

variable "credentials_id" {
  default = ["github_creds"]
}

variable "cloudflare_secrets" {
  type = map(string)
  sensitive = true
  #Cloudflare secrets and the value is assigned on tfvars
}

variable "github_secrets" {
  type = map(string)
  sensitive = true
  #Github secrets and the value is assigned on tfvars
}

variable "jenkins_secrets" {
  type = map(string)
  sensitive = true
  #Github secrets and the value is assigned on tfvars
}