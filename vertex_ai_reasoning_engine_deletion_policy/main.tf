resource "google_vertex_ai_reasoning_engine" "reasoning_engine" {
  display_name    = "reasoning-engine-${local.name_suffix}"
  description     = "A reasoning engine with deletion policy"
  region          = "us-central1"
  deletion_policy = "FORCE"
}
