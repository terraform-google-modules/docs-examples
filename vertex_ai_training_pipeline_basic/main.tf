resource "google_vertex_ai_training_pipeline" "basic_pipeline" {
  display_name             = "test-training-pipeline-${local.name_suffix}"
  model_id                 = "test-model-id-${local.name_suffix}"
  region                   = "us-central1"
  training_task_definition = "gs://google-cloud-aiplatform/schema/trainingjob/definition/custom_task_1.0.0.yaml"

  training_task_inputs = jsonencode({
    workerPoolSpecs = [
      {
        machineSpec = {
          machineType = "n1-standard-4"
        }
        replicaCount = "1"
        diskSpec = {
          bootDiskType   = "pd-ssd"
          bootDiskSizeGb = 100
        }
        containerSpec = {
          imageUri = "gcr.io/cloud-marketplace/google/debian11"
        }
      }
    ]
  })

  labels = {
    env = "test"
  }
}
