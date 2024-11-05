resource "google_container_cluster" "primary" {
  name               = "autopilot-cluster-${local.name_suffix}"
  location           = "us-central1"
  enable_autopilot = true
  ip_allocation_policy {   
  }
  release_channel {
    channel = "RAPID"
  }
  addons_config {
    gke_backup_agent_config {
      enabled = true
    }
  }
  deletion_protection  = false
  network       = "default-${local.name_suffix}"
  subnetwork    = "default-${local.name_suffix}"
}

resource "google_gke_backup_backup_plan" "autopilot" {
  name = "autopilot-plan-${local.name_suffix}"
  cluster = google_container_cluster.primary.id
  location = "us-central1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }
}
