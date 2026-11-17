resource "google_vertex_ai_featurestore" "featurestore" {
  name     = "terraform_featurestore_3-${local.name_suffix}"
  labels = {
    foo = "bar"
  }
  region   = "us-central1"
  online_serving_config {
    scaling {
      min_node_count = 2
      max_node_count = 10
    }
  }
  encryption_spec {
    kms_key_name = "kms-name-${local.name_suffix}"
  }
  force_destroy = true
}
