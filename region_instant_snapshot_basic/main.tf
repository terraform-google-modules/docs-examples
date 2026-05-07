resource "google_compute_region_disk" "foo" {
  name                      = "example-disk-${local.name_suffix}"
  type                      = "pd-ssd"
  region                    = "us-central1"
  size                      = 10
  replica_zones             = ["us-central1-a", "us-central1-f"]
}

resource "google_compute_region_instant_snapshot" "default" {
  name         = "instant-snapshot-${local.name_suffix}"
  region       = "us-central1"
  source_disk  = google_compute_region_disk.foo.self_link
}
