#Initial Setup
variable "do_token" {
  #the value is assigned from tfvars
}

provider "digitalocean" {
  token = var.do_token
}