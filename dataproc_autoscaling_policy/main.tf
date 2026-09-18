resource "google_dataproc_cluster" "basic" {
  name     = "dataproc-policy-${local.name_suffix}"
  region   = "us-east1"

  cluster_config {
    autoscaling_config {
      policy_uri = google_dataproc_autoscaling_policy.asp.name
    }

    master_config {
      num_instances = 1
      machine_type  = "n4-standard-2"
      disk_config {
        boot_disk_type    = "hyperdisk-balanced"
        boot_disk_size_gb = 35
      }
    }

    worker_config {
      num_instances = 2
      machine_type  = "n4-standard-2"
      disk_config {
        boot_disk_type    = "hyperdisk-balanced"
        boot_disk_size_gb = 35
      }
    }
  }
}

resource "google_dataproc_autoscaling_policy" "asp" {
  policy_id = "dataproc-policy-${local.name_suffix}"
  location  = "us-east1"

  worker_config {
    max_instances = 3
  }

  basic_algorithm {
    yarn_config {
      graceful_decommission_timeout = "30s"

      scale_up_factor   = 0.5
      scale_down_factor = 0.5
    }
  }
}
