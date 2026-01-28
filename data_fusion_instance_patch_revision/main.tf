resource "google_data_fusion_instance" "data_fusion_instance_patch_revision" {
  name = "my-instance-${local.name_suffix}"
  region = "us-central1"
  type = "BASIC"
  version = "6.10.1"
  patch_revision = "6.10.1.5"
}
