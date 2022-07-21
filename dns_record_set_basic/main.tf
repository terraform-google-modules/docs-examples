resource "google_dns_managed_zone" "parent-zone" {
  name        = "sample-zone-${local.name_suffix}"
  dns_name    = "sample-zone-${local.name_suffix}.hashicorptest.com."
  description = "Test Description"
}

resource "google_dns_record_set" "default" {
  managed_zone = google_dns_managed_zone.parent-zone.name
  name         = "test-record.sample-zone-${local.name_suffix}.hashicorptest.com."
  type         = "A"
  rrdatas      = ["10.0.0.1", "10.1.0.1"]
  ttl          = 86400
}
