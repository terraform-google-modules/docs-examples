resource "google_vertex_ai_training_pipeline" "encryption_pipeline" {
  display_name             = "test-training-pipeline-enc-${local.name_suffix}"
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

  model_to_upload {
    display_name = "test-model-enc-${local.name_suffix}"
    artifact_uri = "gs://cloud-samples-data/ai-platform/flower_photos"
    container_spec {
      image_uri = "us-docker.pkg.dev/vertex-ai/prediction/tf2-cpu.2-8:latest"
    }
    encryption_spec {
      kms_key_name = "kms-key-${local.name_suffix}"
    }
  }

  encryption_spec {
    kms_key_name = "kms-key-${local.name_suffix}"
  }

  labels = {
    env = "test"
  }
}
