#Naming Standard
variable "unit" {
  type        = string
  description = "business unit code"
  default     = "evm"
}

variable "env" {
  type        = string
  description = "stage environment where the service or cloud resource will be deployed"
  default     = "dev"
}

variable "code" {
  type        = string
  description = "service domain code to use"
  default     = "go"
}

variable "feature" {
  type        = string
  description = "service domain feature to use"
  default     = "demo"
}

variable "region" {
  type        = string
  description = "DO region"
  default     = "sgp1"
}
