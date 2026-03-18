resource "google_dns_managed_zone" "default" {
  name        = "example-zone-${local.name_suffix}"
  dns_name    = "example.com.-${local.name_suffix}"
  description = "Example zone for IAM conditions"
}

resource "google_dns_managed_zone_iam_member" "condition_test" {
  project      = google_dns_managed_zone.default.project
  managed_zone = google_dns_managed_zone.default.name
  role         = "roles/dns.admin"
  member       = "user:admin@hashicorptest.com"

  condition {
    title       = "Exact Record Match"
    description = "Allow modifying only api.example.com. A records"
    # Mandatory pass-through clause for parent Managed Zone checks
    expression = "(resource.type == 'dns.googleapis.com/ResourceRecordSet' && resource.name.endsWith('/rrsets/api.example.com.-${local.name_suffix}/A')) || (resource.type != 'dns.googleapis.com/ResourceRecordSet')"
  }
}
