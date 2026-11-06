resource "google_design_center_space" "example" {
  project  = "my-project-name"
  location = "us-central1"
  space_id = "example-space-${local.name_suffix}"
}
