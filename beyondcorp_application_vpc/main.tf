data "google_project" "project" {}

resource "google_beyondcorp_security_gateway" "default" {
  security_gateway_id = "default-${local.name_suffix}"
  display_name = "My Security Gateway resource"
  hubs { region = "us-central1" }
}

resource "google_beyondcorp_application" "example" {
  security_gateways_id = google_beyondcorp_security_gateway.default.security_gateway_id
  application_id = "my-vm-service-${local.name_suffix}"
  endpoint_matchers {
    hostname = "my-vm-service.com"
  }
  upstreams {
    egress_policy {
      regions = ["us-central1"]
    }
    network {
        name = "projects/${data.google_project.project.project_id}/global/networks/default"
    }
  }
}
