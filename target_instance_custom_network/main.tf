resource "google_compute_target_instance" "custom_network" {
  provider = google-beta
  name     = "custom-network-${local.name_suffix}"
  instance = google_compute_instance.target-vm.id
  network  = data.google_compute_network.target-vm.self_link
}

data "google_compute_network" "target-vm" {
  provider = google-beta
  name = "default"
}

data "google_compute_image" "vmimage" {
  provider = google-beta
  family  = "debian-10"
  project = "debian-cloud"
}

resource "google_compute_instance" "target-vm" {
  provider = google-beta
  name         = "custom-network-target-vm-${local.name_suffix}"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.vmimage.self_link
    }
  }

  network_interface {
    network = "default"
  }
}
