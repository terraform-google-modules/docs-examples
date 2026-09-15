resource "google_vertex_ai_rag_corpus" "example" {
  display_name = "rag-corpus-secret-${local.name_suffix}"
  description  = "A RAG corpus with Secret Manager"
  region       = "europe-west4"

  vector_db_config {
    rag_managed_db {
      knn {}
    }

    api_auth {
      api_key_config {
        api_key_secret_version = google_secret_manager_secret_version.secret_version.name
      }
    }

    rag_embedding_model_config {
      vertex_prediction_endpoint {
        endpoint = "projects/${data.google_project.project.number}/locations/europe-west4/publishers/google/models/text-embedding-005"
      }
    }
  }

  depends_on = [google_secret_manager_secret_iam_member.secret_accessor]
}

resource "google_secret_manager_secret" "secret" {
  secret_id = "secret-key-${local.name_suffix}"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = "secret-api-key"
}

resource "google_secret_manager_secret_iam_member" "secret_accessor" {
  secret_id = google_secret_manager_secret.secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-vertex-rag.iam.gserviceaccount.com"
}

data "google_project" "project" {
}
