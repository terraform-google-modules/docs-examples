resource "google_looker_instance" "looker-instance" {
  name              = "my-instance-${local.name_suffix}"
  platform_edition  = "LOOKER_CORE_STANDARD_ANNUAL"
  region            = "us-central1"
  oauth_config {
    client_id = "my-client-id-${local.name_suffix}"
    client_secret = "my-client-secret-${local.name_suffix}"
  }
  // After your Looker (Google Cloud core) instance has been created, you can set up, view information about, or delete a custom domain for your instance. 
  // Therefore 2 terraform applies, one to create the instance, then another to set up the custom domain. 
  custom_domain {
    domain = "my-custom-domain-${local.name_suffix}.com"
  }
}
