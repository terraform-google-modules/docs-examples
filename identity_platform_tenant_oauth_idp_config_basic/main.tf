resource "google_identity_platform_tenant" "tenant" {
  display_name  = "tenant"
}

resource "google_identity_platform_tenant_oauth_idp_config" "tenant_oauth_idp_config" {
  name          = "oidc.oauth-idp-config-${local.name_suffix}"
  tenant        = google_identity_platform_tenant.tenant.name
  display_name  = "Display Name"
  client_id     = "client-id"
  issuer        = "issuer"
  enabled       = true
  client_secret = "secret"
}
