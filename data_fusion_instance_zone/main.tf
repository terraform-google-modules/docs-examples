resource "google_data_fusion_instance" "zone" {
  name   = "my-instance-${local.name_suffix}"
  region = "us-central1"
  zone   = "us-central1-a"
  type   = "DEVELOPER"
}
