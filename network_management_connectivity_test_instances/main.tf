resource "google_network_management_connectivity_test" "instance-test" {
  name = "conn-test-instances-${local.name_suffix}"
  source {
    instance = google_compute_instance.source.id
  }

  destination {
    instance = google_compute_instance.destination.id
  }

  protocol = "TCP"
}

resource "google_compute_instance" "source" {
  name = "source-vm-${local.name_suffix}"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_9.id
    }
  }

  network_interface {
    network = google_compute_network.vpc.id
    access_config {
    }
  }
}

resource "google_compute_instance" "destination" {
  name = "dest-vm-${local.name_suffix}"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_9.id
    }
  }

  network_interface {
    network = google_compute_network.vpc.id
    access_config {
    }
  }
}

resource "google_compute_network" "vpc" {
  name = "conn-test-net-${local.name_suffix}"
}

data "google_compute_image" "debian_9" {
  family  = "debian-11"
  project = "debian-cloud"
}
