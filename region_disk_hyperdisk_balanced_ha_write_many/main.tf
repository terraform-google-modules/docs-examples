resource "google_compute_region_disk" "primary" {
  name                      = "my-region-hyperdisk-${local.name_suffix}"
  type                      = "hyperdisk-balanced-high-availability"
  region                    = "us-central1"
  replica_zones = ["us-central1-a", "us-central1-f"]
  access_mode = "READ_WRITE_MANY"
}
