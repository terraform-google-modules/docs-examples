resource "google_data_fusion_instance" "basic_instance" {
  name = "my-instance-${local.name_suffix}"
  region = "us-central1"
  type = "BASIC"
  # Mark for testing to avoid service networking connection usage that is not cleaned up
  options = {
    prober_test_run = "true"
  }
}
