resource "google_network_services_grpc_route" "default" {
  provider               = google-beta
  name                   = "my-grpc-route-${local.name_suffix}"
  labels                 = {
    foo = "bar"
  }
  description             = "my description"
  hostnames               = ["example"]
  rules                   {
    matches {
      headers {
        key = "key"
        value = "value"
      }
    }
    action {
      retry_policy {
          retry_conditions = ["cancelled"]
          num_retries = 1
      }
    }
  }
}
