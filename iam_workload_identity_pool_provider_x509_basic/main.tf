resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = "example-pool-${local.name_suffix}"
}

resource "google_iam_workload_identity_pool_provider" "example" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "example-prvdr-${local.name_suffix}"
  attribute_mapping                  = {
    "google.subject"        = "assertion.subject.dn.cn"
  }
  x509 {
    trust_store {
        trust_anchors {
            pem_certificate = file("test-fixtures/trust_anchor.pem")
        }
    }
  }
}
