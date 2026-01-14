resource "google_compute_snapshot" "snapshot" {
  name        = "my-snapshot-${local.name_suffix}"
  zone        = "us-central1-a"
  source_instant_snapshot = google_compute_instant_snapshot.instant_snapshot.id
}

resource "google_compute_instant_snapshot" "instant_snapshot" {
  name        = "my-instant-snapshot-${local.name_suffix}"
  source_disk = google_compute_disk.persistent.self_link
  zone        = google_compute_disk.persistent.zone

  description = "A test snapshot"
  labels = {
	foo = "bar"
  }
}

data "google_compute_image" "debian" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_disk" "persistent" {
  name  = "debian-disk-${local.name_suffix}"
  image = data.google_compute_image.debian.self_link
  size  = 10
  type  = "pd-ssd"
  zone  = "us-central1-a"
}
