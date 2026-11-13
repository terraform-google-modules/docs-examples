resource "google_design_center_catalog" "example" {
  project    = "my-project-name"
  location   = "us-central1"
  space      = "example-space"
  catalog_id = "example-catalog-${local.name_suffix}"
}
