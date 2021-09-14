output "cloudflare_hostname" {
  value = cloudflare_record.record.hostname
}

output "cloudflare_hostname_staging" {
  value = cloudflare_record.staging[0].hostname
}

output "cloudflare_hostname_production" {
  value = cloudflare_record.production[0].hostname
}