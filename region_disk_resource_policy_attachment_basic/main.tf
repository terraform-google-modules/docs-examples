resource "google_compute_region_disk_resource_policy_attachment" "attachment" {
  name = google_compute_resource_policy.policy.name
  disk = google_compute_region_disk.ssd.name
  region = "us-central1"
}

resource "google_compute_disk" "disk" {
  name  = "my-base-disk-${local.name_suffix}"
  image = "debian-cloud/debian-11"
  size  = 50
  type  = "pd-ssd"
  zone  = "us-central1-a"
}

resource "google_compute_snapshot" "snapdisk" {
  name  = "my-snapshot-${local.name_suffix}"
  source_disk = google_compute_disk.disk.name
  zone        = "us-central1-a"
}

resource "google_compute_region_disk" "ssd" {
  name  = "my-disk-${local.name_suffix}"
  replica_zones = ["us-central1-a", "us-central1-f"]
  snapshot = google_compute_snapshot.snapdisk.id
  size  = 50
  type  = "pd-ssd"
  region  = "us-central1"
}

resource "google_compute_resource_policy" "policy" {
  name = "my-resource-policy-${local.name_suffix}"
  region = "us-central1"
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time = "04:00"
      }
    }
  }
}

data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}
