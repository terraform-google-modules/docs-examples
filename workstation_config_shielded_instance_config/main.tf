resource "google_tags_tag_key" "tag_key1" {
  parent     = "organizations/123456789-${local.name_suffix}"
  short_name = "keyname-${local.name_suffix}"
}

resource "google_tags_tag_value" "tag_value1" {
  parent     = google_tags_tag_key.tag_key1.id
  short_name = "valuename-${local.name_suffix}"
}

resource "google_compute_network" "default" {
  name                    = "workstation-cluster-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "workstation-cluster-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-west4"
  network       = google_compute_network.default.name
}

resource "google_workstations_workstation_cluster" "default" {
  workstation_cluster_id = "workstation-cluster-${local.name_suffix}"
  network                = google_compute_network.default.id
  subnetwork             = google_compute_subnetwork.default.id
  location               = "us-west4"

  labels = {
    "label" = "key"
  }

  annotations = {
    label-one = "value-one"
  }
}

resource "google_service_account" "default" {
  account_id   = "my-account-${local.name_suffix}"
  display_name = "Service Account"
}

resource "google_workstations_workstation_config" "default" {
  workstation_config_id  = "workstation-config-${local.name_suffix}"
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = "us-west4"

  enable_audit_agent = true

  host {
    gce_instance {
      machine_type                = "n2d-standard-2"
      boot_disk_size_gb           = 35
      pool_size                   = 1
      service_account             = google_service_account.default.email
      service_account_scopes      = ["https://www.googleapis.com/auth/cloud-platform"]
      disable_public_ip_addresses = false
      tags                        = ["foo", "bar"]

      shielded_instance_config {
        enable_secure_boot          = true
        enable_vtpm                 = true
        enable_integrity_monitoring = true
      }

      confidential_instance_config {
        enable_confidential_compute = true
      }
    }
  }
}
