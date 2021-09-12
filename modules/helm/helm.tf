data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket  = "greyhats13-tfstate"
    key     = "${var.unit}-k8s-cluster-${var.env}.tfstate"
    region  = "ap-southeast-1"
    profile = "${var.unit}-${var.env}"
  }
}

provider "kubernetes" {
  host  = data.terraform_remote_state.k8s.outputs.do_k8s_endpoint
  token = data.terraform_remote_state.k8s.outputs.do_k8s_kubeconfig0.token
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.k8s.outputs.do_k8s_kubeconfig0.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = data.terraform_remote_state.k8s.outputs.do_k8s_endpoint
    token = data.terraform_remote_state.k8s.outputs.do_k8s_kubeconfig0.token
    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.k8s.outputs.do_k8s_kubeconfig0.cluster_ca_certificate
    )
  }
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.feature
  }
}

resource "helm_release" "helm" {
  name       = "${var.unit}-${var.code}-${var.feature}-${var.env}"
  repository = var.repository
  chart      = var.chart
  values     = length(var.values) > 0 ? var.values : []
  namespace  = kubernetes_namespace.namespace.metadata.0.name
  lint       = true
  dynamic "set" {
    for_each = length(var.helm_sets) > 0 ? {
      for helm_key, helm_set in var.helm_sets : helm_key => helm_set
    } : {}
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}
