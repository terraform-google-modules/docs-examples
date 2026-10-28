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
  workstation_config_id   = "workstation-config-${local.name_suffix}"
  workstation_cluster_id  = google_workstations_workstation_cluster.default.workstation_cluster_id
  location                = "us-west4"
  display_name            = "Display Name N"
  idle_timeout            = "1200s"
  running_timeout         = "43200s"
  replica_zones           = ["us-west4-a", "us-west4-b"]
  disable_tcp_connections = true
  max_usable_workstations = 2

  labels = {
    foo = "bar"
  }

  readiness_checks {
    path = "/"
    port = 80
  }

  allowed_ports {
    first = 80
    last  = 80
  }

  host {
    gce_instance {
      machine_type                 = "n1-standard-4"
      boot_disk_size_gb            = 35
      disable_public_ip_addresses  = true
      enable_nested_virtualization = true
      instance_metadata = {
        "startup-key"  = "startup-value"
        "custom-field" = "custom-value"
      }
    }
  }

  container {
    image       = "us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest"
    working_dir = "/test"
    env = {
      NAME = "FOO"
      BABE = "bar"
    }
  }
}
