// Roughly mirrors https://cloud.google.com/load-balancing/docs/https/setting-up-ext-https-hybrid
variable "subnetwork_cidr" {
  default = "10.0.0.0/24"
}

resource "google_compute_network" "default" {
  name                    = "my-network-${local.name_suffix}"
}

resource "google_compute_network" "internal" {
  name                    = "my-internal-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "internal"{
  name                    = "my-subnetwork-${local.name_suffix}"
  network                 = google_compute_network.internal.id
  ip_cidr_range           = var.subnetwork_cidr
  region                  = "us-central1"
  private_ip_google_access= true
}

// Zonal NEG with GCE_VM_IP_PORT
resource "google_compute_network_endpoint_group" "default" {
  name                  = "default-neg-${local.name_suffix}"
  network               = google_compute_network.default.id
  default_port          = "90"
  zone                  = "us-central1-a"
  network_endpoint_type = "GCE_VM_IP_PORT"
}

// Zonal NEG with GCE_VM_IP
resource "google_compute_network_endpoint_group" "internal" {
  name                  = "internal-neg-${local.name_suffix}"
  network               = google_compute_network.internal.id
  subnetwork            = google_compute_subnetwork.internal.id
  zone                  = "us-central1-a"
  network_endpoint_type = "GCE_VM_IP"
}

// Hybrid connectivity NEG
resource "google_compute_network_endpoint_group" "hybrid" {
  name                  = "hybrid-neg-${local.name_suffix}"
  network               = google_compute_network.default.id
  default_port          = "90"
  zone                  = "us-central1-a"
  network_endpoint_type = "NON_GCP_PRIVATE_IP_PORT"
}

resource "google_compute_network_endpoint" "hybrid-endpoint" {
  network_endpoint_group = google_compute_network_endpoint_group.hybrid.name
  port       = google_compute_network_endpoint_group.hybrid.default_port
  ip_address = "127.0.0.1"
}

// Backend service for Zonal NEG
resource "google_compute_backend_service" "default" {
  name                  = "backend-default-${local.name_suffix}"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 10
  backend {
    group = google_compute_network_endpoint_group.default.id
    balancing_mode               = "RATE"
    max_rate_per_endpoint        = 10
  }
  health_checks = [google_compute_health_check.default.id]
}

// Backgend service for Hybrid NEG
resource "google_compute_backend_service" "hybrid" {
  name                  = "backend-hybrid-${local.name_suffix}"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 10
  backend {
    group                        = google_compute_network_endpoint_group.hybrid.id
    balancing_mode               = "RATE"
    max_rate_per_endpoint = 10
  }
  health_checks = [google_compute_health_check.default.id]
}

resource "google_compute_health_check" "default" {
  name               = "health-check-${local.name_suffix}"
  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_url_map" "default" {
  name            = "url-map-target-proxy-${local.name_suffix}"
  description     = "a description"
  default_service = google_compute_backend_service.default.id

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.default.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.default.id
    }

    path_rule {
      paths   = ["/hybrid"]
      service = google_compute_backend_service.hybrid.id
    }
  }
}

resource "google_compute_target_http_proxy" "default" {
  name        = "target-proxy-${local.name_suffix}"
  description = "a description"
  url_map     = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "global-rule-${local.name_suffix}"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
}
