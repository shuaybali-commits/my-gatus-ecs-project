output "application_url" {
  description = "Public HTTPS URL for the Gatus application"
  value       = "https://${module.route53.record_fqdn}"
}
