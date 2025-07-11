data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance_template" "foobar" {
  name           = "instance-template-${local.name_suffix}"
  machine_type   = "n2-standard-2"
  can_ip_forward = false
  tags           = ["foo", "bar"]

  disk {
    source_image = data.google_compute_image.my_image.self_link
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
  }

  scheduling {
    preemptible       = false
    automatic_restart = true
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  labels = {
    my_label = "foobar"
  }
}

resource "google_compute_reservation" "gce_reservation_source_instance_template" {
  name = "gce-reservation-source-instance-template-${local.name_suffix}"
  zone = "us-central1-a"

  specific_reservation {
    count = 1
    source_instance_template = google_compute_instance_template.foobar.self_link
  }
}
