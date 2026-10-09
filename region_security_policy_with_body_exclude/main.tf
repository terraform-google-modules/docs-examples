
resource "google_compute_network" "default" {
  name                    = "test-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "test-network-${local.name_suffix}-subnet"
  region        = "us-west2"
  network       = google_compute_network.default.id
  ip_cidr_range = "10.10.0.0/24"
}

resource "google_compute_region_health_check" "default" {
  name   = "test-health-check-${local.name_suffix}"
  region = "us-west2"

  http_health_check {
    port = 80
  }
}

resource "google_compute_region_security_policy" "policy_rule_one" {
  name        = "policyruletest-${local.name_suffix}"
  description = "regional security policy with body inspection"
  region      = "us-west2"
  type        = "CLOUD_ARMOR"

  advanced_options_config {
    json_parsing = "STANDARD"
    log_level    = "VERBOSE"
  }

  rules {
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
  }

  rules {
    action   = "allow"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
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

resource "google_compute_region_instance_group_manager" "default" {
  name               = "backendpolicy-${local.name_suffix}"
  region             = "us-west2"
  base_instance_name = "backend"

  version {
    instance_template = google_compute_instance_template.default.id
  }

  target_size = 1
}

resource "google_compute_region_backend_service" "default" {
  name                  = "backendpolicy-${local.name_suffix}"
  region                = "us-west2"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 30

  health_checks = [google_compute_region_health_check.default.id]

  backend {
    group           = google_compute_region_instance_group_manager.default.instance_group
    capacity_scaler = 1.0
  }

  security_policy = google_compute_region_security_policy.policy_rule_one.id
}
