provider "google-beta" {}

resource "google_dataproc_cluster" "basic" {
  provider = "google-beta"
  name   = "tf-dataproc-test--${local.name_suffix}"
  region = "us-central1"

  cluster_config {
    autoscaling_config {
      policy_uri = google_dataproc_autoscaling_policy.asp.name
    }
  }
}

resource "google_dataproc_autoscaling_policy" "asp" {
  provider = "google-beta"
  policy_id = "tf-dataproc-test--${local.name_suffix}"
  location = "us-central1"

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
