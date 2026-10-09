
resource "google_compute_network" "default" {
  name                    = "test-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "test-subnet-${local.name_suffix}"
  region        = "us-west2"
  network       = google_compute_network.default.id
  ip_cidr_range = "10.10.0.0/24"
}

resource "google_compute_health_check" "default" {
  name = "test-health-check-${local.name_suffix}"

  http_health_check {
    port = 80
  }
}

resource "google_compute_security_policy" "default" {
  name        = "policyruletest-${local.name_suffix}"
  description = "global security policy with body inspection"
  type        = "CLOUD_ARMOR"

  advanced_options_config {
    json_parsing = "STANDARD"
    log_level    = "VERBOSE"
  }
}

resource "google_compute_instance_template" "default" {
  name         = "backendpolicy-${local.name_suffix}"
  machine_type = "e2-micro"

  disk {
    source_image = "projects/debian-cloud/global/images/family/debian-13"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.id
    access_config {}
  }
}

resource "google_compute_instance_group_manager" "default" {
  name               = "backendpolicy-${local.name_suffix}"
  base_instance_name = "backend"
  zone               = "us-west2-a"

  version {
    instance_template = google_compute_instance_template.default.id
  }

  target_size = 1
}

resource "google_compute_backend_service" "default" {
  name                  = "backendpolicy-${local.name_suffix}"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 30

  health_checks = [google_compute_health_check.default.id]

  backend {
    group = google_compute_instance_group_manager.default.instance_group
  }

  security_policy = google_compute_security_policy.default.id
}

resource "google_compute_security_policy_rule" "policy_rule_one" {
  security_policy = google_compute_security_policy.default.name
  description     = "waf body rule"
  action          = "deny(403)"
  priority        = 100
  preview         = true

  match {
    expr {
      expression = "evaluatePreconfiguredWaf('sqli-v33-stable')"
    }
  }

  preconfigured_waf_config {
    exclusion {
      target_rule_set = "sqli-v33-stable"

      request_body {
        operator = "EQUALS"
        value    = "safe-field"
      }
    }
  }

  depends_on = [
    google_compute_backend_service.default
  ]
}
