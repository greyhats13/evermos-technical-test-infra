#Initial Setup
variable "do_token" {
  #the value is assigned from tfvars
}

variable "github_owner" {
  #the value is assigned from tfvars
}

variable "github_token" {
  #the value is assigned from tfvars
}

provider "github" {
  token        = var.github_token
  owner        = var.github_owner
}

provider "digitalocean" {
  token = var.do_token
}