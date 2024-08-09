resource "google_service_account" "sa" {
  account_id   = "vertex-sa-${local.name_suffix}"
}

resource "google_vertex_ai_index_endpoint_deployed_index" "basic_deployed_index" {
  depends_on = [ google_vertex_ai_index_endpoint.vertex_index_endpoint_deployed, google_service_account.sa ]
  index_endpoint = google_vertex_ai_index_endpoint.vertex_index_endpoint_deployed.id
  index = google_vertex_ai_index.index.id // this is the index that will be deployed onto an endpoint
  deployed_index_id = "deployed_index_id-${local.name_suffix}"
  reserved_ip_ranges = ["vertex-ai-range-${local.name_suffix}"]
  enable_access_logging = false
  display_name = "vertex-deployed-index-${local.name_suffix}"
  deployed_index_auth_config{
    auth_provider{
      audiences = ["123456-my-app"]
      allowed_issuers = ["${google_service_account.sa.email}"]
    }
  }
  automatic_resources{
    max_replica_count = 4
  }
}

resource "google_storage_bucket" "bucket" {
  name     = "bucket-name-${local.name_suffix}"
  location = "us-central1"
  uniform_bucket_level_access = true
}

# The sample data comes from the following link:
# https://cloud.google.com/vertex-ai/docs/matching-engine/filtering#specify-namespaces-tokens
resource "google_storage_bucket_object" "data" {
  name   = "contents/data.json"
  bucket = google_storage_bucket.bucket.name
  content = <<EOF
{"id": "42", "embedding": [0.5, 1.0], "restricts": [{"namespace": "class", "allow": ["cat", "pet"]},{"namespace": "category", "allow": ["feline"]}]}
{"id": "43", "embedding": [0.6, 1.0], "restricts": [{"namespace": "class", "allow": ["dog", "pet"]},{"namespace": "category", "allow": ["canine"]}]}
EOF
}

resource "google_vertex_ai_index" "index" {
  labels = {
    foo = "bar"
  }
  region   = "us-central1"
  display_name = "test-index-${local.name_suffix}"
  description = "index for test"
  metadata {
    contents_delta_uri = "gs://${google_storage_bucket.bucket.name}/contents"
    config {
      dimensions = 2
      approximate_neighbors_count = 150
      shard_size = "SHARD_SIZE_SMALL"
      distance_measure_type = "DOT_PRODUCT_DISTANCE"
      algorithm_config {
        tree_ah_config {
          leaf_node_embedding_count = 500
          leaf_nodes_to_search_percent = 7
        }
      }
    }
  }
  index_update_method = "BATCH_UPDATE"
}

resource "google_vertex_ai_index_endpoint" "vertex_index_endpoint_deployed" {
  display_name = "sample-endpoint"
  description  = "A sample vertex endpoint"
  region       = "us-central1"
  labels       = {
    label-one = "value-one"
  }
  network      = "projects/${data.google_project.project.number}/global/networks/${data.google_compute_network.vertex_network.name}"
}

data "google_compute_network" "vertex_network" {
  name       = "network-name-${local.name_suffix}"
}

data "google_project" "project" {}
