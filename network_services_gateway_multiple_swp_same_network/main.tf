resource "google_certificate_manager_certificate" "default" {
  provider    = google-beta
  name        = "my-certificate-${local.name_suffix}"
  location    = "us-south1"
  self_managed {
    pem_certificate = file("test-fixtures/certificatemanager/cert.pem")
    pem_private_key = file("test-fixtures/certificatemanager/private-key.pem")
  }
}

resource "google_compute_network" "default" {
  provider                = google-beta
  name                    = "my-network-${local.name_suffix}"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  provider      = google-beta
  name          = "my-subnetwork-name-${local.name_suffix}"
  purpose       = "PRIVATE"
  ip_cidr_range = "10.128.0.0/20"
  region        = "us-south1"
  network       = google_compute_network.default.id
  role          = "ACTIVE"
}

resource "google_compute_subnetwork" "proxyonlysubnet" {
  provider      = google-beta
  name          = "my-proxy-only-subnetwork-${local.name_suffix}"
  purpose       = "REGIONAL_MANAGED_PROXY"
  ip_cidr_range = "192.168.0.0/23"
  region        = "us-south1"
  network       = google_compute_network.default.id
  role          = "ACTIVE"
}

resource "google_network_security_gateway_security_policy" "default" {
  provider    = google-beta
  name        = "my-policy-name-${local.name_suffix}"
  location    = "us-south1"
}

resource "google_network_security_gateway_security_policy_rule" "default" {
  provider                = google-beta
  name                    = "my-policyrule-name-${local.name_suffix}"
  location                = "us-south1"
  gateway_security_policy = google_network_security_gateway_security_policy.default.name
  enabled                 = true  
  priority                = 1
  session_matcher         = "host() == 'example.com'"
  basic_profile           = "ALLOW"
}

resource "google_network_services_gateway" "default" {
  provider                             = google-beta
  name                                 = "my-gateway1-${local.name_suffix}"
  location                             = "us-south1"
  addresses                            = ["10.128.0.99"]
  type                                 = "SECURE_WEB_GATEWAY"
  ports                                = [443]
  scope                                = "my-default-scope1-${local.name_suffix}"
  certificate_urls                     = [google_certificate_manager_certificate.default.id]
  gateway_security_policy              = google_network_security_gateway_security_policy.default.id
  network                              = google_compute_network.default.id
  subnetwork                           = google_compute_subnetwork.default.id
  delete_swg_autogen_router_on_destroy = true
  depends_on                           = [google_compute_subnetwork.proxyonlysubnet]
}

resource "google_network_services_gateway" "gateway2" {
  provider                             = google-beta
  name                                 = "my-gateway2-${local.name_suffix}"
  location                             = "us-south1"
  addresses                            = ["10.128.0.98"]
  type                                 = "SECURE_WEB_GATEWAY"
  ports                                = [443]
  scope                                = "my-default-scope2-${local.name_suffix}"
  certificate_urls                     = [google_certificate_manager_certificate.default.id]
  gateway_security_policy              = google_network_security_gateway_security_policy.default.id
  network                              = google_compute_network.default.id
  subnetwork                           = google_compute_subnetwork.default.id
  delete_swg_autogen_router_on_destroy = true
  depends_on                           = [google_compute_subnetwork.proxyonlysubnet]
}
