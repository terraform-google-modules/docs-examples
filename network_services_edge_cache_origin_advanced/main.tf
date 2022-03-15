
resource "google_network_services_edge_cache_origin" "fallback" {
  name                 = "my-fallback-${local.name_suffix}"
  origin_address       = "gs://media-edge-fallback"
  description          = "The default bucket for media edge test"
  max_attempts         = 3
  protocol = "HTTP"
  port = 80

  retry_conditions = [
    "CONNECT_FAILURE",
    "NOT_FOUND",
    "HTTP_5XX",
    "FORBIDDEN",
  ]
  timeout {
    connect_timeout = "10s"
    max_attempts_timeout = "20s"
    response_timeout = "60s"
    read_timeout = "5s"
  }
}

resource "google_network_services_edge_cache_origin" "default" {
  name                 = "my-origin-${local.name_suffix}"
  origin_address       = "gs://media-edge-default"
  failover_origin      = google_network_services_edge_cache_origin.fallback.id
  description          = "The default bucket for media edge test"
  max_attempts         = 2
  labels = {
    a = "b"
  }

  timeout {
    connect_timeout = "10s"
  }
}
