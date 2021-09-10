terraform {
  backend "s3" {
    bucket  = "greyhats13-tfstate"
    region  = "ap-southeast-1"
    key     = "evm-k8s-cluster-dev.tfstate"
    profile = "evm-dev"
  }
}

module "k8s" {
  source         = "../../modules/k8s"
  region         = "sgp1"
  env            = "dev"
  unit           = "evm"
  code           = "k8s"
  feature        = ["cluster", "pool"]
  version_prefix = "1.21."
  node_type      = "s-2vcpu-2gb"
  node_count     = 2
  auto_scale     = true
  min_nodes      = 2
  max_nodes      = 4
  node_labels = {
    service  = "backend"
    priority = "high"
  }
  node_taint = {}
}
