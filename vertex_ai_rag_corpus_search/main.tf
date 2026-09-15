resource "google_vertex_ai_rag_corpus" "example" {
  display_name = "rag-corpus-search-${local.name_suffix}"
  description  = "A RAG corpus with Vertex AI Search"
  region       = "europe-west4"

  vertex_ai_search_config {
    serving_config = "projects/${data.google_project.project.number}/locations/global/collections/default_collection/engines/test/servingConfigs/default_serving_config"
  }
}

data "google_project" "project" {
}
