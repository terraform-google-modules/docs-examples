resource "google_design_center_space" "example" {
  project                     = "my-project-name"
  location                    = "us-central1"
  space_id                    = "example-space-${local.name_suffix}"
  display_name                = "Updated Example Design Center Space"
  description                 = "Updated Managed by Terraform"
  enable_gcp_shared_templates = true
}
