resource "google_compute_network" "ilb_network" {
  name                    = "l7-ilb-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "proxy_subnet" {
  name          = "l7-ilb-proxy-subnet-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-west1"
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = google_compute_network.ilb_network.id
}

resource "google_compute_subnetwork" "ilb_subnet" {
  name          = "l7-ilb-subnet-${local.name_suffix}"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-west1"
  network       = google_compute_network.ilb_network.id

  depends_on = [
    google_compute_subnetwork.proxy_subnet
  ]
}

resource "google_compute_region_health_check" "default" {
  name   = "l7-ilb-hc-${local.name_suffix}"
  region = "us-west1"

  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_region_backend_service" "default" {
  name                  = "l7-ilb-backend-${local.name_suffix}"
  region                = "us-west1"
  protocol              = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec           = 10
  health_checks         = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_backend_service" "callouts_backend" {
  name                  = "l7-ilb-callouts-backend-${local.name_suffix}"
  region                = "us-west1"
  protocol              = "HTTP2"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec           = 10
  port_name             = "grpc"
  health_checks         = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_url_map" "default" {
  name            = "l7-ilb-regional-url-map-${local.name_suffix}"
  region          = "us-west1"
  default_service = google_compute_region_backend_service.default.id

  host_rule {
    hosts        = ["service-extensions.com"]
    path_matcher = "callouts"
  }

  path_matcher {
    name            = "callouts"
    default_service = google_compute_region_backend_service.callouts_backend.id
  }
}

resource "google_compute_region_target_http_proxy" "default" {
  name    = "l7-ilb-target-http-proxy-${local.name_suffix}"
  region  = "us-west1"
  url_map = google_compute_region_url_map.default.id
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "l7-ilb-forwarding-rule-${local.name_suffix}"
  region                = "us-west1"
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default.id
  network               = google_compute_network.ilb_network.id
  subnetwork            = google_compute_subnetwork.ilb_subnet.id
  network_tier          = "PREMIUM"

  depends_on = [
    google_compute_subnetwork.proxy_subnet
  ]
}

resource "google_network_services_lb_route_extension" "default" {
  name                  = "l7-ilb-route-ext-${local.name_suffix}"
  description           = "my route extension"
  location              = "us-west1"
  load_balancing_scheme = "INTERNAL_MANAGED"
  forwarding_rules      = [google_compute_forwarding_rule.default.self_link]
  metadata              = { key1 = "value1", fr = "{forwarding_rule_id}" }

  extension_chains {
    name = "chain1"

    match_condition {
      cel_expression = "request.path.startsWith('/extensions')"
    }

    extensions {
      name      = "ext11"
      authority = "ext11.com"
      service   = google_compute_region_backend_service.callouts_backend.self_link
      timeout   = "0.1s"
      fail_open = false

      forward_headers = ["custom-header"]
    }
  }
}
