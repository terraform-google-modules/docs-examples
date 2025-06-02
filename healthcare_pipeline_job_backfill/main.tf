resource "google_healthcare_pipeline_job" "example-pipeline" {
  name  = "example_backfill_pipeline-${local.name_suffix}"
  location = "us-central1"
  dataset = google_healthcare_dataset.dataset.id
  backfill_pipeline_job {
    mapping_pipeline_job = "${google_healthcare_dataset.dataset.id}/pipelineJobs/example_mapping_pipeline_job-${local.name_suffix}"
  }      
}

resource "google_healthcare_dataset" "dataset" {
  name     = "example_dataset-${local.name_suffix}"
  location = "us-central1"
}
