resource "google_compute_disk" "foo" {
  name = "example-disk-${local.name_suffix}"
  type = "pd-ssd"
  size = 10
}

resource "google_compute_instant_snapshot" "default" {
  name         = "instant-snapshot-${local.name_suffix}"
  zone         = "us-central1-a"
  source_disk  = google_compute_disk.foo.self_link
}
