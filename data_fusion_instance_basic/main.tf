resource "google_data_fusion_instance" "basic_instance" {
  name   = "my-instance-${local.name_suffix}"
  region = "us-central1"
  type   = "BASIC"
  -${local.name_suffix}
}
