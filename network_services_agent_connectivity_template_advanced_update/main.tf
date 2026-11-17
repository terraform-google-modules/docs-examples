data "google_project" "project" {}

resource "google_compute_network" "default" {
  name                    = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "my-subnetwork-${local.name_suffix}"
  region        = "us-west2"
  network       = google_compute_network.default.id
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_network_attachment" "default" {
  name                  = "my-attachment-${local.name_suffix}"
  region                = "us-west2"
  connection_preference = "ACCEPT_AUTOMATIC"
  subnetworks           = [google_compute_subnetwork.default.id]
}

resource "google_dns_managed_zone" "default" {
  name        = "my-zone-${local.name_suffix}"
  dns_name    = "example.com."
  description = "Private zone used by AgentGateway DNS peering"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.default.id
    }
  }
}

resource "google_certificate_manager_trust_config" "default" {
  name        = "my-trust-config-${local.name_suffix}"
  location    = "us-west2"

  trust_stores {
    trust_anchors { 
      pem_certificate = file("test-fixtures/cert.pem")
    }
    intermediate_cas { 
      pem_certificate = file("test-fixtures/cert.pem")
    }
  }
}

resource "google_network_services_agent_connectivity_template" "default" {
  agent_connectivity_template_id = "my-connectivity-template-${local.name_suffix}"
  location                       = "us-west2"
  description                    = "An updated advanced configuration for Agent Connectivity Template"

  agent_compute    = "CLOUD_RUN"
  deployment_model = "AMBIENT"
  access_types     = ["PUBLIC"]
  access_path      = "AGENT_TO_ANYWHERE"

  labels = {
    env = "prod"
  }

  egress_network_config {
    vpc_egress = "PRIVATE_RANGES_ONLY"
    network_attachment = google_compute_network_attachment.default.id
    dns_peering_config {
      # domain is deprecated but still supported; the API merges it with domains.
      domain         = google_dns_managed_zone.default.dns_name
      domains        = ["sub.example.com."]
      target_network = google_compute_network.default.id
    }
    tls_config {
      trust_config = "projects/${data.google_project.project.number}/locations/us-west2/trustConfigs/${google_certificate_manager_trust_config.default.name}"
      additional_roots = "NO_ADDITIONAL_ROOTS"
    }
  }
}
