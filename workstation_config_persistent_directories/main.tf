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

resource "google_compute_disk" "my_source_disk" {
  name = "workstation-config-${local.name_suffix}"
  size = 10
  type = "pd-ssd"
  zone = "us-west4-a"
}

resource "google_compute_snapshot" "my_source_snapshot" {
  name        = "workstation-config-${local.name_suffix}"
  source_disk = google_compute_disk.my_source_disk.name
  zone        = "us-west4-a"
}

resource "google_compute_image" "my_source_image" {
  name              = "workstation-config-${local.name_suffix}"
  source_disk       = google_compute_disk.my_source_disk.self_link
  storage_locations = ["us-west4"]
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

resource "google_workstations_workstation_config" "default" {
  workstation_config_id  = "workstation-config-${local.name_suffix}"
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = "us-west4"

  persistent_directories {
    mount_path = "/home"
    gce_pd {
      source_snapshot = google_compute_snapshot.my_source_snapshot.id
      reclaim_policy  = "DELETE"
    }
  }
}

resource "google_workstations_workstation_config" "persistent" {
  workstation_config_id  = "workstation-config-${local.name_suffix}-pd"
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = "us-west4"

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

  persistent_directories {
    mount_path = "/home"
    gce_pd {
      size_gb        = 200
      fs_type        = "ext4"
      disk_type      = "pd-standard"
      reclaim_policy = "DELETE"
    }
  }
}

resource "google_workstations_workstation_config" "ephemeral_snapshot" {
  workstation_config_id  = "workstation-config-${local.name_suffix}-eph-snap"
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = "us-west4"

  ephemeral_directories {
    mount_path = "/cache"
    gce_pd {
      source_snapshot = google_compute_snapshot.my_source_snapshot.id
      read_only       = true
    }
  }
}

resource "google_workstations_workstation_config" "ephemeral_image" {
  workstation_config_id  = "workstation-config-${local.name_suffix}-eph-img"
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = "us-west4"

  ephemeral_directories {
    mount_path = "/cache"
    gce_pd {
      disk_type    = "pd-standard"
      source_image = google_compute_image.my_source_image.id
    }
  }
}
