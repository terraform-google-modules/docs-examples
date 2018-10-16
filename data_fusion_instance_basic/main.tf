resource "google_data_fusion_instance" "basic_instance" {
  provider = "google-beta"
  name = "my-instance-${local.name_suffix}"
  region = "us-central1"
  type = "BASIC"
}
