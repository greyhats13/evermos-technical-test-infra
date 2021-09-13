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

variable "github_repository" {
  type        = string
  description = "Github repository name"
}

variable "github_username" {
  type        = string
  description = "github username/owner"
}

variable "jenkins_secrets" {
  type        = map(string)
  description = "jenkins username and password"
}

variable "credentials_id" {
  type        = list(string)
  description = "List of jenkins credentials_id"
}
