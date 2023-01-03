data "google_project" "project" {
}

resource "google_container_attached_cluster" "primary" {
  name     = "basic-${local.name_suffix}"
  location = "us-west1"
  project = data.google_project.project.project_id
  description = "Test cluster"
  distribution = "aks"
  oidc_config {
      issuer_url = "https://oidc.issuer.url"
  }
  platform_version = "1.24.0-gke.1"
  fleet {
    project = "projects/${data.google_project.project.number}"
  }
}
