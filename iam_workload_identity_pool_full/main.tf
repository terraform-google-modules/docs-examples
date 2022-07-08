resource "google_iam_workload_identity_pool" "example" {
  workload_identity_pool_id = "example-pool-${local.name_suffix}"
  display_name              = "Name of pool"
  description               = "Identity pool for automated test"
  disabled                  = true
}
