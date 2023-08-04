resource "google_alloydb_cluster" "full" {
  cluster_id   = "alloydb-cluster-full-${local.name_suffix}"
  location     = "us-central1"
  network      = google_compute_network.default.id

  initial_user {
    user     = "alloydb-cluster-full-${local.name_suffix}"
    password = "alloydb-cluster-full-${local.name_suffix}"
  }

  continuous_backup_config {
    enabled              = true
    recovery_window_days = 14
  }

  automated_backup_policy {
    location      = "us-central1"
    backup_window = "1800s"
    enabled       = true

    weekly_schedule {
      days_of_week = ["MONDAY"]

      start_times {
        hours   = 23
        minutes = 0
        seconds = 0
        nanos   = 0
      }
    }

    quantity_based_retention {
      count = 1
    }

    labels = {
      test = "alloydb-cluster-full-${local.name_suffix}"
    }
  }

  labels = {
    test = "alloydb-cluster-full-${local.name_suffix}"
  }
}

data "google_project" "project" {}

resource "google_compute_network" "default" {
  name = "alloydb-cluster-full-${local.name_suffix}"
}
