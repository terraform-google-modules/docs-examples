resource "google_vertex_ai_tensorboard" "tensorboard" {
  display_name = "terraform-${local.name_suffix}"
  description  = "sample description"
  labels       = {
    "key1" : "value1",
    "key2" : "value2"
  }
  region       = "us-central1"
}
