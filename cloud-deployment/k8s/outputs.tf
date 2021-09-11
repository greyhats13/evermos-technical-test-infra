output "do_k8s_id" {
  value = module.k8s.k8s_id
}

output "do_vpc_urn" {
  value = module.k8s.k8s_urn
}

output "do_k8s_endpoint" {
  value = module.k8s.k8s_endpoint
}

output "do_k8s_kubeconfig0" {
  value     = module.k8s.k8s_kubeconfig0
  sensitive = true
}
