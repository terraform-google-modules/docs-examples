resource "google_compute_instance" "vm" {
  provider     = google-beta
  name         = "my-vm-${local.name_suffix}"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
  }
}

resource "google_compute_machine_image" "image" {
  provider        = google-beta
  name            = "my-image-${local.name_suffix}"
  source_instance = google_compute_instance.vm.self_link
}
