data "google_project" "project" {}

resource "google_network_services_agent_connectivity_template" "default" {
  agent_connectivity_template_id = "my-connectivity-template-${local.name_suffix}"
  location                       = "us-west2"
  description                    = "A basic configuration for Agent Connectivity Template"
  labels = {
    env  = "test"
    tier = "gold"
  }

  agent_compute    = "GKE"
  deployment_model = "CENTRALIZED"
  access_path      = "CLIENT_TO_AGENT"
}
