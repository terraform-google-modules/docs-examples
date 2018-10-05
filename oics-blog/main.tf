resource "google_compute_instance" "instance" {
	name                      = "vm-instance-${local.name_suffix}"
	machine_type              = "f1-micro"
	zone                      = "us-central1-a"
	allow_stopping_for_update = true

	boot_disk {
		initialize_params{
			image = "${data.google_compute_image.debian_image.self_link}"
		}
	}

	network_interface {
		network = "default"
		access_config {
		}
	}
}

data "google_compute_image" "debian_image" {
	family  = "debian-9"
	project = "debian-cloud"
}

