resource "google_certificate_manager_certificate" "default" {
  name        = "self-managed-cert-${local.name_suffix}"
  description = "Global cert"
  scope       = "ALL_REGIONS"
  self_managed {
    pem_certificate = file("test-fixtures/cert.pem")
    pem_private_key = file("test-fixtures/private-key.pem")
  }
}
