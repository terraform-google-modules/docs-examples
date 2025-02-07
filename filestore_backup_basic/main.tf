resource "google_filestore_instance" "instance" {
  name     = "fs-inst-${local.name_suffix}"
  location = "us-central1-b"
  tier     = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network      = "default"
    modes        = ["MODE_IPV4"]
    connect_mode = "DIRECT_PEERING"
  }
}

resource "google_filestore_backup" "backup" {
  name              = "fs-bkup-${local.name_suffix}"
  location          = "us-central1"
  description       = "This is a filestore backup for the test instance"
  source_instance   = google_filestore_instance.instance.id
  source_file_share = "share1"

  labels = {
    "files":"label1",
    "other-label": "label2"
  }
}
