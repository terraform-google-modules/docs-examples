resource "google_certificate_manager_certificate" "default" {
  name        = "dns-cert-${local.name_suffix}"
  description = "regional managed certs"
  location = "us-central1"
  managed {
    domains = [
      google_certificate_manager_dns_authorization.instance.domain,
      ]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.instance.id,
      ]
  }
}
resource "google_certificate_manager_dns_authorization" "instance" {
  name        = "dns-auth-${local.name_suffix}"
  location    = "us-central1"
  description = "The default dnss"
  domain      = "subdomain-${local.name_suffix}.hashicorptest.com"
}
