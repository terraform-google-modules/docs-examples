data "google_project" "project" {
}

data "google_container_attached_versions" "versions" {
	location       = "us-west1"
	project        = data.google_project.project.project_id
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
  platform_version = data.google_container_attached_versions.versions.valid_versions[0]
  fleet {
    project = "projects/${data.google_project.project.number}"
  }

  deletion_policy = "DELETE_IGNORE_ERRORS"
}
