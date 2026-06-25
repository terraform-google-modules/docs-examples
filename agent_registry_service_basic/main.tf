resource "google_agent_registry_service" "default" {
  location     = "us-central1"
  service_id   = "service-${local.name_suffix}"
  description  = "My basic agent registry service"
  display_name = "My Service"

  interfaces {
    url              = "https://www.google.com/service-${local.name_suffix}"
    protocol_binding = "GRPC"
  }

  agent_spec {
    type = "NO_SPEC"
  }
}
