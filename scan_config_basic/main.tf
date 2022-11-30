resource "google_compute_address" "scanner_static_ip" {
  provider = google-beta
  name     = "scan-basic-static-ip-${local.name_suffix}"
}

resource "google_security_scanner_scan_config" "scan-config" {
  provider         = google-beta
  display_name     = "terraform-scan-config-${local.name_suffix}"
  starting_urls    = ["http://${google_compute_address.scanner_static_ip.address}"]
  target_platforms = ["COMPUTE"]
}
