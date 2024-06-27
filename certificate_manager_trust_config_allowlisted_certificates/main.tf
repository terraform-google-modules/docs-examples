resource "google_certificate_manager_trust_config" "default" {
  name        = "trust-config-${local.name_suffix}"
  description = "A sample trust config resource with allowlisted certificates"
  location = "global"

  allowlisted_certificates  {
    pem_certificate = file("test-fixtures/cert.pem") 
  }
  allowlisted_certificates  {
    pem_certificate = file("test-fixtures/cert2.pem") 
  }
  
  labels = {
    foo = "bar"
  }
}
