resource "google_data_fusion_instance" "enterprise_instance" {
  name = "my-instance-${local.name_suffix}"
  region = "us-central1"
  type = "ENTERPRISE"
  enable_rbac = true
  # Mark for testing to avoid service networking connection usage that is not cleaned up
  options = {
    prober_test_run = "true"
  }
}
