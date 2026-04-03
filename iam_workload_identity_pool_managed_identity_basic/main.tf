resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = "example-pool-${local.name_suffix}"
  mode                      = "TRUST_DOMAIN"
}

resource "google_iam_workload_identity_pool_namespace" "ns" {
  workload_identity_pool_id           = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_namespace_id = "example-namespace-${local.name_suffix}"
}

resource "google_iam_workload_identity_pool_managed_identity" "example" {
  workload_identity_pool_id                  = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_namespace_id        = google_iam_workload_identity_pool_namespace.ns.workload_identity_pool_namespace_id
  workload_identity_pool_managed_identity_id = "example-managed-identity-${local.name_suffix}"
}
