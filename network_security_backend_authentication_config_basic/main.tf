resource "google_network_security_backend_authentication_config" "default" {
  name             = "my-backend-authentication-config-${local.name_suffix}"
  labels           = {
    foo = "bar"
  }
  description      = "my description"
  well_known_roots = "PUBLIC_ROOTS"
}
