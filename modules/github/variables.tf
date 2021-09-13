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

variable "github_secrets" {
  type        = map(string)
  description = "Github secrets"
}
