resource google_vertex_ai_feature_online_store "feature_online_store" {
    name = "example_feature_online_store-${local.name_suffix}"
    region = "us-central1"
    labels = {
        label-one = "value-one"
    }

    bigtable {
        auto_scaling {
            min_node_count = 1
            max_node_count = 2
            cpu_utilization_target = 60
        }
    }
}
