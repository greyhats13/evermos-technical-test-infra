#Naming Standard
variable "unit" {
  type        = string
  description = "business unit code"
}

variable "env" {
  type        = string
  description = "stage environment where the service or cloud resource will be deployed"
}

variable "code" {
  type        = string
  description = "service domain code to use"
}

variable "feature" {
  type        = string
  description = "service domain feature to use"
}

#cloudflare

variable "cloudflare_secrets" {
  type        = map(string)
  description = "Cloudflare secrets"
}

variable "zone_id" {
  type        = string
  description = "cloudflare zone id"
}

variable "type" {
  type        = string
  description = "Cloudflare type"
}

variable "ttl" {
  type        = number
  description = "cloudflare ttl"
}

variable "proxied" {
  type        = bool
  description = "Cloudflare proxy"
}

variable "allow_overwrite" {
  type        = bool
  description = "Cloudflare allow overwrite record"
}
