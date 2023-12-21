resource "google_vertex_ai_feature_online_store" "feature_online_store" {
  name = "example_feature_online_store-${local.name_suffix}"
  labels = {
    foo = "bar"
  }
  region = "us-central1"
  bigtable {
    auto_scaling {
      min_node_count         = 1
      max_node_count         = 3
      cpu_utilization_target = 50
    }
  }
}
