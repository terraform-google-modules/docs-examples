resource "google_dns_managed_zone" "cloud-logging-enabled-zone" {
  name        = "cloud-logging-enabled-zone-${local.name_suffix}"
  dns_name    = "services.example.com."
  description = "Example cloud logging enabled DNS zone"
  labels = {
    foo = "bar"
  }

  cloud_logging_config {
    enable_logging = true
  }
}
