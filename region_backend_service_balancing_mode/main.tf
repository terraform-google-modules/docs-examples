resource "google_compute_region_backend_service" "default" {
  load_balancing_scheme = "INTERNAL_MANAGED"

  backend {
    group          = google_compute_region_instance_group_manager.rigm.instance_group
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }

  region      = "us-central1"
  name        = "region-service-${local.name_suffix}"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_region_health_check.default.id]
}

data "google_compute_image" "debian_image" {
  family   = "debian-11"
  project  = "debian-cloud"
}

resource "google_compute_region_instance_group_manager" "rigm" {
  region   = "us-central1"
  name     = "rbs-rigm-${local.name_suffix}"
  version {
    instance_template = google_compute_instance_template.instance_template.id
    name              = "primary"
  }
  base_instance_name = "internal-glb"
  target_size        = 1
}

resource "google_compute_instance_template" "instance_template" {
  name         = "template-region-service-${local.name_suffix}"
  machine_type = "e2-medium"

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
  }

  disk {
    source_image = data.google_compute_image.debian_image.self_link
    auto_delete  = true
    boot         = true
  }

  tags = ["allow-ssh", "load-balanced-backend"]
}

resource "google_compute_region_health_check" "default" {
  region = "us-central1"
  name   = "rbs-health-check-${local.name_suffix}"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_network" "default" {
  name                    = "rbs-net-${local.name_suffix}"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "default" {
  name          = "rbs-net-${local.name_suffix}-default"
  ip_cidr_range = "10.1.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.default.id
}
