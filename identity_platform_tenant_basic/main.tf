resource "google_identity_platform_tenant" "tenant" {
  display_name          = "tenant"
  allow_password_signup = true
}
