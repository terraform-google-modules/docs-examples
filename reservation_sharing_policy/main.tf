data "google_compute_image" "my_image" {
  family = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance_template" "foobar" {
  name = "instance-template-${local.name_suffix}"
  machine_type = "g2-standard-4"
  can_ip_forward = false
  tags = ["foo", "bar"]

  disk {
    source_image = data.google_compute_image.my_image.self_link
    auto_delete = true
    boot = true
  }

  network_interface {
    network = "default"
  }

  scheduling {
    preemptible = false
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

resource "google_compute_reservation" "gce_reservation_sharing_policy" {
  name = "gce-reservation-sharing-policy-${local.name_suffix}"
  zone = "us-central1-b"

  specific_reservation {
    count = 2
    source_instance_template = google_compute_instance_template.foobar.self_link
  }

  reservation_sharing_policy {
    service_share_type = "ALLOW_ALL"
  }
}
