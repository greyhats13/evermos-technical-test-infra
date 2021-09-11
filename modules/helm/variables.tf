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

variable "region" {
  type        = string
  description = "DO region"
}

variable "repository" {
  type        = string
  description = "Helm chart repository"
}

variable "chart" {
  type        = string
  description = "helm chart"
}

variable "values" {
  type        = list(string)
  description = "helm values file"
}

variable "helm_sets" {
  type        = list(object({ name : string, value : any }))
  description = "(optional) describe your variable"
}
