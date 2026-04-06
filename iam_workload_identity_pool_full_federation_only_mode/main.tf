resource "google_iam_workload_identity_pool" "example" {
  workload_identity_pool_id = "example-pool-${local.name_suffix}"
  display_name              = "Name of the pool"
  description               = "Identity pool operates in FEDERATION_ONLY mode"
  disabled                  = true
  mode                      = "FEDERATION_ONLY"
}
