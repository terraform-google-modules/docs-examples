resource "google_identity_platform_inbound_saml_config" "saml_config" {
  name         = "saml.tf-config-${local.name_suffix}"
  display_name = "Display Name"
  idp_config {
    idp_entity_id = "tf-idp-${local.name_suffix}"
    sign_request  = true
    sso_url       = "https://example.com"
    idp_certificates {
      x509_certificate = file("test-fixtures/rsa_cert.pem")
    }
  }

  sp_config {
    sp_entity_id = "tf-sp-${local.name_suffix}"
    callback_uri = "https://example.com"
  }
}
