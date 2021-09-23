resource "google_network_services_edge_cache_origin" "default" {
  name                 = "my-origin-${local.name_suffix}"
  origin_address       = "gs://media-edge-default"
  description          = "The default bucket for media edge test"
}
