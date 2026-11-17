resource "google_gke_backup_restore_channel" "basic" {
  name = "basic-channel-${local.name_suffix}"
  location = "us-east1"
  description = "Description"
  destination_project = "projects/24240755850-${local.name_suffix}"
  labels = { "key": "some-value" }
}
