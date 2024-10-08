data "google_project" "project" {
}

resource "google_network_security_server_tls_policy" "default" {
  name     = "my-server-tls-policy-${local.name_suffix}"

  description = "my description"
  location    = "global"
  allow_open  = "false"

  mtls_policy {
    client_validation_mode         = "REJECT_INVALID"
    client_validation_trust_config = "projects/${data.google_project.project.number}/locations/global/trustConfigs/${google_certificate_manager_trust_config.default.name}"
  }

  labels = {
    foo = "bar"
  }
}

resource "google_certificate_manager_trust_config" "default" {
  name        = "my-trust-config-${local.name_suffix}"
  description = "sample trust config description"
  location    = "global"

  trust_stores {
    trust_anchors {
      pem_certificate = file("test-fixtures/ca_cert.pem")
    }
    intermediate_cas {
      pem_certificate = file("test-fixtures/ca_cert.pem")
    }
  }

  labels = {
    foo = "bar"
  }
}
