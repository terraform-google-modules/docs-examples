resource "google_compute_network" "default" {
  provider                = google-beta
  name                    = "workstation-cluster-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  provider      = google-beta
  name          = "workstation-cluster-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.default.name
}

resource "google_workstations_workstation_cluster" "default" {
  provider               = google-beta
  workstation_cluster_id = "workstation-cluster-${local.name_suffix}"
  network                = google_compute_network.default.id
  subnetwork             = google_compute_subnetwork.default.id
  location               = "us-central1"
  
  labels = {
    "label" = "key"
  }

  annotations = {
    label-one = "value-one"
  }
}

resource "google_kms_key_ring" "default" {
  name     = "workstation-cluster-${local.name_suffix}"
  location = "global"
  provider = google-beta
}

resource "google_kms_crypto_key" "default" {
  name            = "workstation-cluster-${local.name_suffix}"
  key_ring        = google_kms_key_ring.default.id
  provider        = google-beta
}

resource "google_service_account" "default" {
  account_id   = "my-account-${local.name_suffix}"
  display_name = "Service Account"
  provider = google-beta
}

resource "google_workstations_workstation_config" "default" {
  provider               = google-beta
  workstation_config_id  = "workstation-config-${local.name_suffix}"
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location   		         = "us-central1"

  host {
    gce_instance {
      machine_type                = "e2-standard-4"
      boot_disk_size_gb           = 35
      disable_public_ip_addresses = true
      shielded_instance_config {
        enable_secure_boot = true
        enable_vtpm        = true
      }
    }
  }

  encryption_key {
    kms_key                 = google_kms_crypto_key.default.id
    kms_key_service_account = google_service_account.default.email
  }
}
