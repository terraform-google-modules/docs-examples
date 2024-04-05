
resource "google_compute_instance_settings" "gce_instance_settings" {
  zone = "us-east7-b"
  metadata {
    items = {
      foo = "baz"
    }
  }
}
