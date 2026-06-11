resource "google_vertex_ai_tensorboard" "tensorboard" {
  display_name = "Tensorboard for Experiment"
  region       = "us-central1"
}

resource "google_vertex_ai_tensorboard_experiment" "tensorboard_experiment" {
  location                = "us-central1"
  display_name            = "sample experiment updated"
  description             = "updated description"
  tensorboard             = basename(google_vertex_ai_tensorboard.tensorboard.id)
  tensorboard_experiment_id = "experiment-${local.name_suffix}"
  source                  = "a custom training job"
  labels                  = {
    "key" : "value-updated"
    "new-key" : "new-value"
  }
}
