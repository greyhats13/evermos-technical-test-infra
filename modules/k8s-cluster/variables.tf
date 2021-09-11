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
  type        = list(string)
  description = "the name of DO services feature"
}

variable "region" {
  type        = string
  description = "DO region"
}

#k8s
variable "version_prefix" {
  type        = string
  description = "k8s version prefix"
}

variable "node_type" {
  type        = string
  description = "k8s node type"
}

variable "auto_scale" {
  type        = bool
  description = "k8s autoscale"
}

variable "min_nodes" {
  type        = number
  description = "k8s min nodes"
}

variable "max_nodes" {
  type        = number
  description = "k8s max nodes"
}

variable "node_labels" {
  type        = map(any)
  description = "k8s node labels"
}

variable "node_taint" {
  type        = map(any)
  description = "k8s node taints"
}
