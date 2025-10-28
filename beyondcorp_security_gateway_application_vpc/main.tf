data "google_project" "project" {}

resource "google_beyondcorp_security_gateway" "default" {
  security_gateway_id = "default-sg-${local.name_suffix}"
  display_name = "My Security Gateway resource"
  hubs { region = "us-central1" }
}

resource "google_beyondcorp_security_gateway_application" "example" {
  security_gateway_id = google_beyondcorp_security_gateway.default.security_gateway_id
  application_id = "my-vm-service2-${local.name_suffix}"
  endpoint_matchers {
    hostname = "my-vm-service.com"
    ports = [80, 443]
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
