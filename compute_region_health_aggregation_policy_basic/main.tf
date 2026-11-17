data "google_project" "project" {
}

resource "google_compute_region_health_aggregation_policy" "example_test_health_aggregation_policy" {
  name        = "test-health-aggregation-policy-${local.name_suffix}"
  description = "Example health aggregation policy basic-${local.name_suffix}"
  region      = "us-central1"
}
