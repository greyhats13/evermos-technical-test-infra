output "k8s_id" {
  value = digitalocean_kubernetes_cluster.cluster.id
}

output "k8s_urn" {
  value = digitalocean_kubernetes_cluster.cluster.urn
}

output "k8s_endpoint" {
  value = digitalocean_kubernetes_cluster.cluster.endpoint
}

output "k8s_kubeconfig0" {
  value = digitalocean_kubernetes_cluster.cluster.kube_config.0
}
