resource "google_filestore_instance" "instance" {
  name     = "test-instance-${local.name_suffix}"
  location = "us-central1"
  tier     = "ENTERPRISE"
  protocol = "NFS_V4_1"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }

}
