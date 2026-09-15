resource "google_vertex_ai_rag_corpus" "example" {
  display_name = "rag-corpus-vector-search-${local.name_suffix}"
  description  = "A RAG corpus with Vertex Vector Search"
  region       = "europe-west4"

  vector_db_config {
    vertex_vector_search {
      index_endpoint = "projects/${data.google_project.project.number}/locations/europe-west4/indexEndpoints/${google_vertex_ai_index_endpoint.index_endpoint.name}"
      index          = "projects/${data.google_project.project.number}/locations/europe-west4/indexes/${google_vertex_ai_index.index.name}"
    }

    rag_embedding_model_config {
      vertex_prediction_endpoint {
        endpoint = "projects/${data.google_project.project.number}/locations/europe-west4/publishers/google/models/text-embedding-005"
      }
    }
  }

  depends_on = [google_vertex_ai_index_endpoint_deployed_index.deployed_index]
}

resource "google_vertex_ai_index" "index" {
  region              = "europe-west4"
  display_name        = "index-test-${local.name_suffix}"
  description         = "test index"
  index_update_method = "STREAM_UPDATE"
  metadata {
    config {
      dimensions            = 768
      distance_measure_type = "COSINE_DISTANCE"
      feature_norm_type     = "UNIT_L2_NORM"
      algorithm_config {
        brute_force_config {}
      }
    }
  }
}

resource "google_vertex_ai_index_endpoint" "index_endpoint" {
  display_name            = "endpoint-test-${local.name_suffix}"
  description             = "test endpoint"
  region                  = "europe-west4"
  public_endpoint_enabled = true
}

resource "google_vertex_ai_index_endpoint_deployed_index" "deployed_index" {
  deployed_index_id = "deployed_index-${local.name_suffix}"
  display_name      = "deployed_index-${local.name_suffix}"
  region            = "europe-west4"
  index             = google_vertex_ai_index.index.id
  index_endpoint    = google_vertex_ai_index_endpoint.index_endpoint.id
  automatic_resources {
    min_replica_count = 1
    max_replica_count = 1
  }
}

data "google_project" "project" {
}
