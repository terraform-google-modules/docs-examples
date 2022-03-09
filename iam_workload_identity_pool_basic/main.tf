resource "google_iam_workload_identity_pool" "example" {
  provider                  = google-beta
  workload_identity_pool_id = "example-pool-${local.name_suffix}"
}
