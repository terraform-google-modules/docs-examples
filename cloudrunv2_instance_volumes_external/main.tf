resource "google_storage_bucket" "default" {
  name                        = "cr-gcs-${local.name_suffix}"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_cloud_run_v2_instance" "default" {
  name                = "cloudrun-instance-${local.name_suffix}"
  location            = "us-east4"

  containers {
    image = "us-docker.pkg.dev/cloudrun/container/hello"
    volume_mounts {
      name       = "gcs-volume"
      mount_path = "/mnt/gcs"
    }
  }

  volumes {
    name = "gcs-volume"
    gcs {
      bucket        = google_storage_bucket.default.name
      read_only     = false
      mount_options = ["log-severity=info"]
    }
  }
}
