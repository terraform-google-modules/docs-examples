resource "google_vertex_ai_training_pipeline" "fraction_split_pipeline" {
  display_name             = "test-training-pipeline-fraction-${local.name_suffix}"
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

  input_data_config {
    dataset_id = google_vertex_ai_dataset.dataset.name

    fraction_split {
      training_fraction   = 0.8
      validation_fraction = 0.1
      test_fraction       = 0.1
    }

    gcs_destination {
      output_uri_prefix = "gs://${google_storage_bucket.bucket.name}/dataset-export"
    }
  }

  labels = {
    env = "test"
  }
}

resource "google_vertex_ai_dataset" "dataset" {
  display_name        = "test-dataset-fraction-${local.name_suffix}"
  metadata_schema_uri = "gs://google-cloud-aiplatform/schema/dataset/metadata/tabular_1.0.0.yaml"
  region              = "us-central1"
}

resource "google_storage_bucket" "bucket" {
  name                        = "test-bucket-fraction-${local.name_suffix}"
  location                    = "us-central1"
  force_destroy               = true
  uniform_bucket_level_access = true
}
