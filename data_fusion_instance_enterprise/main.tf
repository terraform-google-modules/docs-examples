resource "google_data_fusion_instance" "enterprise_instance" {
  name = "my-instance-${local.name_suffix}"
  region = "us-central1"
  type = "ENTERPRISE"
  enable_rbac = true
  -${local.name_suffix}
}
