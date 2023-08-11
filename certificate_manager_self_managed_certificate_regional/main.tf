resource "google_certificate_manager_certificate" "default" {
  name        = "self-managed-cert-${local.name_suffix}"
  description = "Regional cert"
  location    = "us-central1"
  self_managed {
    pem_certificate = file("test-fixtures/cert.pem")
    pem_private_key = file("test-fixtures/private-key.pem")
  }
}
