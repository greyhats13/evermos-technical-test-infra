terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "evm-k8s-cluster-dev.tfstate"
    profile = "evm-dev"
  }
}

#Initial Setup
variable "do_token" {
  #the value is assigned from tfvars
}

module "k8s_cluster" {
  source         = "../../modules/k8s-cluster"
  region         = "sgp1"
  env            = "dev"
  unit           = "evm"
  code           = "k8s"
  feature        = ["cluster", "pool"]
  do_token       = var.do_token
  version_prefix = "1.21."
  node_type      = "s-2vcpu-2gb"
  auto_scale     = true
  min_nodes      = 2
  max_nodes      = 4
  node_labels = {
    service  = "backend"
    priority = "high"
  }
  node_taint = {}
  namespaces = [ "dev", "stg", "evermos", "ingress", "cicd", "database" ]
}
