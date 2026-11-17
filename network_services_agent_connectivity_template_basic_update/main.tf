data "google_project" "project" {}

resource "google_network_services_agent_connectivity_template" "default" {
  agent_connectivity_template_id = "my-connectivity-template-${local.name_suffix}"
  location                       = "us-west2"
  description                    = "An updated configuration for Agent Connectivity Template"
  labels = {
    env  = "prod"
    tier = "platinum"
    new_label = "added"
  }
  agent_compute    = "CLOUD_RUN"
  deployment_model = "AMBIENT"
  access_path      = "CLIENT_TO_AGENT"
}
