data "google_project" "project" {}

resource "google_privateca_ca_pool" "ca_pool" {
  name     = "ca-pool-${local.name_suffix}"
  location = "us-central1"
  tier     = "ENTERPRISE"
  publishing_options {
    publish_ca_cert = true
    publish_crl     = true
  }
}

resource "google_privateca_certificate_authority" "root_ca" {
  pool                     = google_privateca_ca_pool.ca_pool.name
  certificate_authority_id = "root-ca-${local.name_suffix}"
  location                 = "us-central1"
  config {
    subject_config {
      subject {
        organization = "google"
        common_name = "my-certificate-authority"
      }
    }
    x509_config {
      ca_options {
        is_ca = true
      }
      key_usage {
        base_key_usage {
          cert_sign = true
          crl_sign = true
        }
        extended_key_usage {
          server_auth = true
        }
      }
    }
  }
  key_spec {
    algorithm = "RSA_PKCS1_4096_SHA256"
  }

  // Disable deletion protections for easier test cleanup purposes
  deletion_protection = false
  ignore_active_certificates_on_deletion = true
  skip_grace_period = true
}

resource "google_privateca_ca_pool_iam_binding" "ca_pool_binding" {
  ca_pool = google_privateca_ca_pool.ca_pool.id
  role = "roles/privateca.certificateRequester"

  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-sourcemanager.iam.gserviceaccount.com"
  ]
}

// See https://cloud.google.com/secure-source-manager/docs/create-private-service-connect-instance#root-ca-api
resource "google_secure_source_manager_instance" "default" {
  instance_id = "my-instance-${local.name_suffix}"
  location = "us-central1"
  private_config {
    is_private = true
    ca_pool = google_privateca_ca_pool.ca_pool.id
  }
  depends_on = [
    google_privateca_certificate_authority.root_ca,
    time_sleep.wait_120_seconds
  ]
}

# ca pool IAM permissions can take time to propagate
resource "time_sleep" "wait_120_seconds" {
  depends_on = [google_privateca_ca_pool_iam_binding.ca_pool_binding]

  create_duration = "120s"
}

// Connect SSM private instance with L4 proxy ILB.
resource "google_compute_network" "network" {
  name = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name = "my-subnet-${local.name_suffix}"
  region = "us-central1"
  network = google_compute_network.network.id
  ip_cidr_range = "10.0.1.0/24"
  private_ip_google_access = true
}

resource "google_compute_region_network_endpoint_group" "psc_neg" {
  name = "my-neg-${local.name_suffix}"
  region = "us-central1"

  network_endpoint_type = "PRIVATE_SERVICE_CONNECT"
  psc_target_service = google_secure_source_manager_instance.default.private_config.0.http_service_attachment

  network = google_compute_network.network.id
  subnetwork = google_compute_subnetwork.subnet.id
}

resource "google_compute_region_backend_service" "backend_service" {
  name = "my-backend-service-${local.name_suffix}"
  region = "us-central1"
  protocol = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  backend {
    group = google_compute_region_network_endpoint_group.psc_neg.id
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_subnetwork" "proxy_subnet" {
  name = "my-proxy-subnet-${local.name_suffix}"
  region = "us-central1"
  network = google_compute_network.network.id
  ip_cidr_range = "10.0.2.0/24"
  purpose = "REGIONAL_MANAGED_PROXY"
  role = "ACTIVE"
}

resource "google_compute_region_target_tcp_proxy" "target_proxy" {
  name = "my-target-proxy-${local.name_suffix}"
  region = "us-central1"
  backend_service = google_compute_region_backend_service.backend_service.id
}

resource "google_compute_forwarding_rule" "fw_rule_target_proxy" {
  name = "fw-rule-target-proxy-${local.name_suffix}"
  region = "us-central1"

  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_protocol = "TCP"
  port_range = "443"
  target = google_compute_region_target_tcp_proxy.target_proxy.id
  network = google_compute_network.network.id
  subnetwork = google_compute_subnetwork.subnet.id
  network_tier = "PREMIUM"
  depends_on = [google_compute_subnetwork.proxy_subnet]
}

resource "google_dns_managed_zone" "private_zone" {
  name = "my-dns-zone-${local.name_suffix}"
  dns_name = "p.sourcemanager.dev."
  visibility = "private"
  private_visibility_config {
    networks {
      network_url = google_compute_network.network.id
    }
  }
}

resource "google_dns_record_set" "ssm_instance_html_record" {
  name = "${google_secure_source_manager_instance.default.host_config.0.html}."
  type = "A"
  ttl = 300
  managed_zone = google_dns_managed_zone.private_zone.name
  rrdatas = [google_compute_forwarding_rule.fw_rule_target_proxy.ip_address]
}

resource "google_dns_record_set" "ssm_instance_api_record" {
  name = "${google_secure_source_manager_instance.default.host_config.0.api}."
  type = "A"
  ttl = 300
  managed_zone = google_dns_managed_zone.private_zone.name
  rrdatas = [google_compute_forwarding_rule.fw_rule_target_proxy.ip_address]
}

resource "google_dns_record_set" "ssm_instance_git_record" {
  name = "${google_secure_source_manager_instance.default.host_config.0.git_http}."
  type = "A"
  ttl = 300
  managed_zone = google_dns_managed_zone.private_zone.name
  rrdatas = [google_compute_forwarding_rule.fw_rule_target_proxy.ip_address]
}