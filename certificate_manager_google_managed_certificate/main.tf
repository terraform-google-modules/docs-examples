resource "google_certificate_manager_certificate" "default" {
  name        = "dns-cert-${local.name_suffix}"
  description = "The default cert"
  scope       = "EDGE_CACHE"
  managed {
    domains = [
      google_certificate_manager_dns_authorization.instance.domain,
      google_certificate_manager_dns_authorization.instance2.domain,
      ]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.instance.id,
      google_certificate_manager_dns_authorization.instance2.id,
      ]
  }
}


resource "google_certificate_manager_dns_authorization" "instance" {
  name        = "dns-auth-${local.name_suffix}"
  description = "The default dnss"
  domain      = "subdomain-${local.name_suffix}.hashicorptest.com"
}

resource "google_certificate_manager_dns_authorization" "instance2" {
  name        = "dns-auth2-${local.name_suffix}"
  description = "The default dnss"
  domain      = "subdomain2-${local.name_suffix}.hashicorptest.com"
}
