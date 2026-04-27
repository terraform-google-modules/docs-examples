resource "google_vertex_ai_reasoning_engine" "reasoning_engine" {
  display_name = "reasoning-engine-${local.name_suffix}"
  description  = "A basic reasoning engine"
  labels       = {
    "key" = "value"
  }
  region       = "us-central1"
}
