resource "google_compute_target_instance" "default" {
  name     = "target-${local.name_suffix}"
  instance = google_compute_instance.target-vm.id
}

data "google_compute_image" "vmimage" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance" "target-vm" {
  name         = "target-vm-${local.name_suffix}"
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
