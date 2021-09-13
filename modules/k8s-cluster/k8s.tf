provider "digitalocean" {
  token = var.do_token
}

data "terraform_remote_state" "project" {
  backend = "s3"
  config = {
    bucket  = "greyhats13-tfstate"
    key     = "${var.unit}-project-${var.env}.tfstate"
    region  = "ap-southeast-1"
    profile = "${var.unit}-${var.env}"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "greyhats13-tfstate"
    key     = "${var.unit}-vpc-network-${var.env}.tfstate"
    region  = "ap-southeast-1"
    profile = "${var.unit}-${var.env}"
  }
}

#assign k8s cluster to project
resource "digitalocean_project_resources" "project_resource" {
  project = data.terraform_remote_state.project.outputs.do_project_id
  resources = [
    digitalocean_kubernetes_cluster.cluster.urn
  ]
}

data "digitalocean_kubernetes_versions" "versions" {
  version_prefix = var.version_prefix
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "${var.unit}-${var.code}-${var.feature[0]}-${var.env}"
  region  = var.region
  version = data.digitalocean_kubernetes_versions.versions.latest_version

  node_pool {
    name       = "${var.unit}-${var.code}-${var.feature[1]}-${var.env}"
    size       = var.node_type
    auto_scale = var.auto_scale
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes
    labels     = var.node_labels
    dynamic "taint" {
      for_each = length(var.node_taint) > 0 ? var.node_taint : {}
      content {
        key    = taint.value["key"]
        value  = taint.value["value"]
        effect = taint.value["effect"]
      }
    }
  }
  tags     = [var.unit, var.code, var.feature[0], var.env]
  vpc_uuid = data.terraform_remote_state.vpc.outputs.do_vpc_id
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# resource "digitalocean_kubernetes_node_pool" "autoscale-pool-01" {
#   cluster_id = digitalocean_kubernetes_cluster.cluster.id
#   name       = "${var.unit}-${var.code}-${var.feature[1]}-${var.env}-autoscale"
#   size       = var.node_type
#   auto_scale = var.auto_scale
#   min_nodes  = var.min_nodes
#   max_nodes  = var.max_nodes
#   labels     = var.node_labels
# }

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.cluster.endpoint
  token = digitalocean_kubernetes_cluster.cluster.kube_config.0.token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate
  )
  experiments {
    manifest_resource = true
  }
}

resource "kubernetes_namespace" "namespaces" {
  count = length(var.namespaces)
  metadata {
    name = element(var.namespaces, count.index)
  }
}
