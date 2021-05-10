# [START compute_vm_packet_mirror]
resource "google_compute_packet_mirroring" "default" {
  project     = var.project_id # Replace this with your project ID in quotes
  name        = "my-mirroring"
  description = "My packet mirror"
  network {
    url = var.network # Replace with self link to your VPC network in quotes
  }
  collector_ilb {
    url = var.ilb # Replace with self link to your internal load balancer's forwarding rule in quotes
  }
  mirrored_resources {
    tags = ["foo"]
    instances {
      url = var.vm # Replace with self link to VM instance in quotes
    }
  }
  filter {
    ip_protocols = ["tcp"]
    cidr_ranges  = ["0.0.0.0/0"]
    direction    = "BOTH"
  }
}
# [END compute_vm_packet_mirror]

resource "google_compute_network" "default" {
  project                 = google_compute_packet_mirroring.default.project
  name                    = "new-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  project       = google_compute_packet_mirroring.default.project
  name          = "my-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = "new-network"
}

resource "google_compute_instance" "mirror" {
  project      = google_compute_packet_mirroring.default.project
  name         = "my-instance"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.id
    access_config {
    }
  }
}

resource "google_compute_region_backend_service" "default" {
  project       = google_compute_packet_mirroring.default.project
  name          = "my-service"
  health_checks = [google_compute_health_check.default.id]
}

resource "google_compute_health_check" "default" {
  project            = google_compute_packet_mirroring.default.project
  name               = "my-healthcheck"
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_forwarding_rule" "default" {
  depends_on             = [google_compute_subnetwork.default]
  name                   = "my-ilb"
  project                = google_compute_packet_mirroring.default.project
  is_mirroring_collector = true
  ip_protocol            = "TCP"
  load_balancing_scheme  = "INTERNAL"
  backend_service        = google_compute_region_backend_service.default.id
  all_ports              = true
  network                = google_compute_packet_mirroring.default.id
  subnetwork             = google_compute_subnetwork.default.id
  network_tier           = "PREMIUM"
}
