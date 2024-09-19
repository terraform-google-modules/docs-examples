resource "google_healthcare_pipeline_job" "example-pipeline" {
  name  = "example_pipeline_job-${local.name_suffix}"
  location = "us-central1"
  dataset = google_healthcare_dataset.dataset.id
  disable_lineage = true
  reconciliation_pipeline_job {
    merge_config {
      description = "sample description for reconciliation rules"
      whistle_config_source {
        uri = "gs://${google_storage_bucket.bucket.name}/${google_storage_bucket_object.merge_file.name}"
        import_uri_prefix = "gs://${google_storage_bucket.bucket.name}"
      }
    }
    matching_uri_prefix = "gs://${google_storage_bucket.bucket.name}"
    fhir_store_destination = "${google_healthcare_dataset.dataset.id}/fhirStores/${google_healthcare_fhir_store.fhirstore.name}"
  }
}

resource "google_healthcare_dataset" "dataset" {
  name     = "example_dataset-${local.name_suffix}"
  location = "us-central1"
}

resource "google_healthcare_fhir_store" "fhirstore" {
  name    = "fhir_store-${local.name_suffix}"
  dataset = google_healthcare_dataset.dataset.id
  version = "R4"
  enable_update_create          = true
  disable_referential_integrity = true
}

resource "google_storage_bucket" "bucket" {
    name          = "example_bucket_name-${local.name_suffix}"
    location      = "us-central1"
    uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "merge_file" {
  name    = "merge.wstl"
  content = " "
  bucket  = google_storage_bucket.bucket.name
}
