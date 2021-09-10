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
  description = "the name of DO services feature"
}

variable "region" {
  type        = string
  description = "DO region"
}

#vpc
variable "ip_range" {
  type        = string
  description = "IP range"
}