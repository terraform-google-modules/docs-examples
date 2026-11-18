resource "google_design_center_share" "example" {
  project           = "my-project-name"
  location          = "us-central1"
  space             = "example-space"
  catalog           = "example-catalog"
  share_id          = "example-share-${local.name_suffix}"
  destination_space = "projects/my-project-name/locations/us-central1/spaces/destination-space"
}
