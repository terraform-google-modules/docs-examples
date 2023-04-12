resource "google_network_services_mesh" "default" {
  provider    = google-beta
  name        = "my-http-route-${local.name_suffix}"
  labels      = {
    foo = "bar"
  }
  description = "my description"
}

resource "google_network_services_http_route" "default" {
  provider               = google-beta
  name                   = "my-http-route-${local.name_suffix}"
  labels                 = {
    foo = "bar"
  }
  description             = "my description"
  hostnames               = ["example"]
  meshes = [
    google_network_services_mesh.default.id
  ]
  rules                   {
    matches {
      query_parameters {
        query_parameter = "key"
        exact_match = "value"
      }
      full_path_match = "example"
    }
  }
}
