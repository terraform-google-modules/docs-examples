// Forwarding rule for Internal Load Balancing
resource "google_compute_forwarding_rule" "default" {
  provider = google-beta
  depends_on = [google_compute_subnetwork.proxy]
  name   = "website-forwarding-rule-${local.name_suffix}"
  region = "us-central1"

  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default.self_link
  network               = google_compute_network.default.self_link
  subnetwork            = google_compute_subnetwork.default.self_link
  network_tier          = "PREMIUM"
}

resource "google_compute_region_target_http_proxy" "default" {
  provider = google-beta

  region  = "us-central1"
  name    = "website-proxy-${local.name_suffix}"
  url_map = google_compute_region_url_map.default.self_link
}

resource "google_compute_region_url_map" "default" {
  provider = google-beta

  region          = "us-central1"
  name            = "website-map-${local.name_suffix}"
  default_service = google_compute_region_backend_service.default.self_link
}

resource "google_compute_region_backend_service" "default" {
  provider = google-beta

  load_balancing_scheme = "INTERNAL_MANAGED"

  backend {
    group = google_compute_region_instance_group_manager.rigm.instance_group
    balancing_mode = "UTILIZATION"
  }

  region      = "us-central1"
  name        = "website-backend-${local.name_suffix}"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_region_health_check.default.self_link]
}

data "google_compute_image" "debian_image" {
  provider = google-beta
  family   = "debian-9"
  project  = "debian-cloud"
}

resource "google_compute_region_instance_group_manager" "rigm" {
  provider = google-beta
  region   = "us-central1"
  name     = "rigm-internal"
  version {
    instance_template = google_compute_instance_template.instance_template.self_link
    name              = "primary"
  }
  base_instance_name = "internal-glb"
  target_size        = 1
}

resource "google_compute_instance_template" "instance_template" {
  provider     = google-beta
  name         = "template-website-backend-${local.name_suffix}"
  machine_type = "n1-standard-1"

  network_interface {
    network = google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.default.self_link
  }

  disk {
    source_image = data.google_compute_image.debian_image.self_link
    auto_delete  = true
    boot         = true
  }

  tags = ["allow-ssh", "load-balanced-backend"]
}

resource "google_compute_region_health_check" "default" {
  depends_on = [google_compute_firewall.fw4]
  provider = google-beta

  region = "us-central1"
  name   = "website-hc-${local.name_suffix}"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_firewall" "fw1" {
  provider = google-beta
  name = "website-fw-${local.name_suffix}-1"
  network = google_compute_network.default.self_link
  source_ranges = ["10.1.2.0/24"]
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }
  direction = "INGRESS"
}

resource "google_compute_firewall" "fw2" {
  depends_on = [google_compute_firewall.fw1]
  provider = google-beta
  name = "website-fw-${local.name_suffix}-2"
  network = google_compute_network.default.self_link
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  target_tags = ["allow-ssh"]
  direction = "INGRESS"
}

resource "google_compute_firewall" "fw3" {
  depends_on = [google_compute_firewall.fw2]
  provider = google-beta
  name = "website-fw-${local.name_suffix}-3"
  network = google_compute_network.default.self_link
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["load-balanced-backend"]
  direction = "INGRESS"
}

resource "google_compute_firewall" "fw4" {
  depends_on = [google_compute_firewall.fw3]
  provider = google-beta
  name = "website-fw-${local.name_suffix}-4"
  network = google_compute_network.default.self_link
  source_ranges = ["10.129.0.0/26"]
  target_tags = ["load-balanced-backend"]
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  allow {
    protocol = "tcp"
    ports = ["443"]
  }
  allow {
    protocol = "tcp"
    ports = ["8000"]
  }
  direction = "INGRESS"
}

resource "google_compute_network" "default" {
  provider = google-beta
  name                    = "website-net-${local.name_suffix}"
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
}

resource "google_compute_subnetwork" "default" {
  provider = google-beta
  name          = "website-net-${local.name_suffix}-default"
  ip_cidr_range = "10.1.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.default.self_link
}

resource "google_compute_subnetwork" "proxy" {
  provider = google-beta
  name          = "website-net-${local.name_suffix}-proxy"
  ip_cidr_range = "10.129.0.0/26"
  region        = "us-central1"
  network       = google_compute_network.default.self_link
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
}
