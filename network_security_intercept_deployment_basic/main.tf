resource "google_compute_network" "network" {
  name                    = "example-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "example-subnet-${local.name_suffix}"
  region        = "us-central1"
  ip_cidr_range = "10.1.0.0/16"
  network       = google_compute_network.network.name
}

resource "google_compute_region_health_check" "health_check" {
  name   = "example-hc-${local.name_suffix}"
  region = "us-central1"
  http_health_check {
    port = 80
  }
}

resource "google_compute_region_backend_service" "backend_service" {
  name                  = "example-bs-${local.name_suffix}"
  region                = "us-central1"
  health_checks         = [google_compute_region_health_check.health_check.id]
  protocol              = "UDP"
  load_balancing_scheme = "INTERNAL"
}

resource "google_compute_forwarding_rule" "forwarding_rule" {
  name                  = "example-fwr-${local.name_suffix}"
  region                = "us-central1"
  network               = google_compute_network.network.name
  subnetwork            = google_compute_subnetwork.subnetwork.name
  backend_service       = google_compute_region_backend_service.backend_service.id
  load_balancing_scheme = "INTERNAL"
  ports                 = [6081]
  ip_protocol           = "UDP"
}

resource "google_network_security_intercept_deployment_group" "deployment_group" {
  intercept_deployment_group_id = "example-dg-${local.name_suffix}"
  location                      = "global"
  network                       = google_compute_network.network.id
}

resource "google_network_security_intercept_deployment" "default" {
  intercept_deployment_id    = "example-deployment-${local.name_suffix}"
  location                   = "us-central1-a"
  forwarding_rule            = google_compute_forwarding_rule.forwarding_rule.id
  intercept_deployment_group = google_network_security_intercept_deployment_group.deployment_group.id
  description                = "some description"
  labels = {
    foo = "bar"
  }
}
