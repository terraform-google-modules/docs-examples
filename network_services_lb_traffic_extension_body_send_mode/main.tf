resource "google_compute_global_forwarding_rule" "default" {
  name                  = "l7-ext-fr-${local.name_suffix}"
  target                = google_compute_target_http_proxy.default.id
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  network_tier          = "PREMIUM"
}

resource "google_compute_target_http_proxy" "default" {
  name        = "l7-ext-proxy-${local.name_suffix}"
  description = "a description"
  url_map     = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "l7-ext-urlmap-${local.name_suffix}"
  description     = "a description"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name                  = "l7-ext-backend-${local.name_suffix}"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 10
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_backend_service" "callouts_backend" {
  name                  = "l7-ext-callout-${local.name_suffix}"
  port_name             = "grpc"
  protocol              = "HTTP2"
  timeout_sec           = 10
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_network_services_lb_traffic_extension" "default" {
  name        = "l7-ext-traffic-ext-${local.name_suffix}"
  description = "my traffic extension"
  location    = "global"

  load_balancing_scheme = "EXTERNAL_MANAGED"
  forwarding_rules      = [google_compute_global_forwarding_rule.default.self_link]

  extension_chains {
    name = "chain1"

    match_condition {
      cel_expression = "request.host == 'example.com'"
    }

    extensions {
      name      = "ext11"
      authority = "ext11.com"
      service   = google_compute_backend_service.callouts_backend.self_link
      timeout   = "0.1s"
      fail_open = false

      supported_events        = ["REQUEST_HEADERS", "REQUEST_BODY", "RESPONSE_HEADERS", "RESPONSE_BODY"]
      request_body_send_mode  = "BODY_SEND_MODE_STREAMED"
      response_body_send_mode = "BODY_SEND_MODE_STREAMED"
    }
  }
}
