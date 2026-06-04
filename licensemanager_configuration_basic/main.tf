# Reference design doc: go/lima-terraform
resource "google_license_manager_configuration" "example-configuration" {
  location         = "us-central1"
  configuration_id = "example-configuration-${local.name_suffix}"
  product          = "Office2021ProfessionalPlus"
  license_count    = 10
}
