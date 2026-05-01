resource "google_tags_tag_key" "tag_key1" {
  parent     = "organizations/0123456789-${local.name_suffix}"
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
  region        = "us-central1"
  network       = google_compute_network.default.name
}

resource "google_compute_disk" "my_source_disk" {
  name  = "workstation-config-${local.name_suffix}-source-disk"
  size  = 10
  type  = "pd-ssd"
  zone  = "us-central1-a"
}

resource "google_compute_snapshot" "my_source_snapshot" {
  name        = "workstation-config-${local.name_suffix}-source-snapshot"
  source_disk = google_compute_disk.my_source_disk.name
  zone        = "us-central1-a"
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
        machine_type                = "c3-standard-22"
        boot_disk_size_gb           = 35
        disable_public_ip_addresses = true
        vm_tags = {
          (google_tags_tag_key.tag_key1.id) = google_tags_tag_value.tag_value1.id
        }
      }
    }

  persistent_directories {
    mount_path = "/home"
    gce_hd {
      source_snapshot = google_compute_snapshot.my_source_snapshot.id
      reclaim_policy  = "DELETE"
      archive_timeout = "3600s"
    }
  }
}
