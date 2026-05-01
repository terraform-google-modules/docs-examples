resource "google_compute_network" "default" {
  name                    = "workstation-cluster-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "workstation-cluster-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.default.name
}

resource "google_workstations_workstation_cluster" "default" {
  workstation_cluster_id = "workstation-cluster-${local.name_suffix}"
  network                = google_compute_network.default.id
  subnetwork             = google_compute_subnetwork.default.id
  location               = "us-central1"
}

resource "google_workstations_workstation_config" "default" {
  workstation_config_id  = "workstation-config-${local.name_suffix}"
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = "us-central1"

  host {
    gce_instance {
      # C3 machine types require Hyperdisk storage
      machine_type = "c3-standard-22"
    }
  }

  persistent_directories {
    mount_path = "/home"
    gce_hd {
      size_gb         = 200
      reclaim_policy  = "DELETE"
      archive_timeout = "3600s"
    }
  }
}
