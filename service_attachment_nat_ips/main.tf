resource "google_compute_service_attachment" "psc_ilb_service_attachment" {
  name        = "my-psc-ilb-${local.name_suffix}"
  region      = "us-central1"
  description = "A service attachment configured with Terraform"

  enable_proxy_protocol    = true
  nat_ips_per_endpoint     = 2
  connection_preference    = "ACCEPT_AUTOMATIC"
  nat_subnets              = [google_compute_subnetwork.psc_ilb_nat.id]
  target_service           = google_compute_forwarding_rule.psc_ilb_target_service.id
}


resource "google_compute_forwarding_rule" "psc_ilb_target_service" {
  name   = "producer-forwarding-rule-${local.name_suffix}"
  region = "us-central1"

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.producer_service_backend.id
  all_ports             = true
  network               = google_compute_network.psc_ilb_network.name
  subnetwork            = google_compute_subnetwork.psc_ilb_producer_subnetwork.name
}

resource "google_compute_region_backend_service" "producer_service_backend" {
  name   = "producer-service-${local.name_suffix}"
  region = "us-central1"

  health_checks = [google_compute_health_check.producer_service_health_check.id]
}

resource "google_compute_health_check" "producer_service_health_check" {
  name = "producer-service-health-check-${local.name_suffix}"

  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_network" "psc_ilb_network" {
  name = "psc-ilb-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "psc_ilb_producer_subnetwork" {
  name   = "psc-ilb-producer-subnetwork-${local.name_suffix}"
  region = "us-central1"

  network       = google_compute_network.psc_ilb_network.id
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_subnetwork" "psc_ilb_nat" {
  name   = "psc-ilb-nat-${local.name_suffix}"
  region = "us-central1"

  network       = google_compute_network.psc_ilb_network.id
  purpose       =  "PRIVATE_SERVICE_CONNECT"
  ip_cidr_range = "10.1.0.0/16"
}
