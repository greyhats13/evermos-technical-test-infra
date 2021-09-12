output "jenkins_cloudflare_endpoint" {
  value = module.cloudflare.cloudflare_hostname
}

# output "do_helm_metadata" {
#   value = module.helm.helm_metadata
# }
