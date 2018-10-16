resource "google_app_engine_domain_mapping" "domain_mapping" {
  domain_name = "dm-test--${local.name_suffix}.gcp.tfacc.hashicorptest.com"

  ssl_settings {
    ssl_management_type = "AUTOMATIC"
  }
}
