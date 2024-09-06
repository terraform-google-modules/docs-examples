data "google_project" "project" {
}

data "google_container_attached_versions" "versions" {
	location       = "us-west1"
	project        = data.google_project.project.project_id
}

resource "google_container_attached_cluster" "primary" {
  name     = "basic-${local.name_suffix}"
  project = data.google_project.project.project_id
  location = "us-west1"
  description = "Test cluster"
  distribution = "aks"
  annotations = {
    label-one = "value-one"
  }
  authorization {
    admin_users = [ "user1@example.com", "user2@example.com"]
    admin_groups = [ "group1@example.com", "group2@example.com"]
  }
  oidc_config {
      issuer_url = "https://oidc.issuer.url"
      jwks = base64encode("{\"keys\":[{\"use\":\"sig\",\"kty\":\"RSA\",\"kid\":\"testid\",\"alg\":\"RS256\",\"n\":\"somedata\",\"e\":\"AQAB\"}]}")
  }
  platform_version = data.google_container_attached_versions.versions.valid_versions[0]
  fleet {
    project = "projects/${data.google_project.project.number}"
  }
  logging_config {
    component_config {
      enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
    }
  }
  monitoring_config {
    managed_prometheus_config {
      enabled = true
    }
  }
  binary_authorization {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }
  proxy_config {
    kubernetes_secret {
      name = "proxy-config"
      namespace = "default"
    }
  }
  security_posture_config {
    vulnerability_mode = "VULNERABILITY_ENTERPRISE"
  }
}
