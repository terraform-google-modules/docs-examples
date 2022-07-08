resource "google_iam_workload_identity_pool" "example" {
  workload_identity_pool_id = "example-pool-${local.name_suffix}"
}
