resource "google_certificate_manager_dns_authorization" "default" {
  name        = "dns-auth-${local.name_suffix}"
  location    = "us-central1"
  description = "reginal dns"
  type        = "PER_PROJECT_RECORD"
  domain      = "subdomain-${local.name_suffix}.hashicorptest.com"
}
