resource "google_storage_bucket" "bucket" {
  name          = "tf-sample-bucket-${local.name_suffix}"
  location      = "us-central1"
  force_destroy = true
}

resource "google_storage_batch_operations_job" "tf-job" {
  job_id      = "tf-job-${local.name_suffix}"
  description = "A sample job description"
  dry_run     = true
  bucket_list {
    buckets {
      bucket = google_storage_bucket.bucket.name
      prefix_list {
        included_object_prefixes = [
          "bkt"
        ]
      }
    }
  }
  put_metadata {
    custom_metadata = {
      "key" = "value"
    }
  }
  logging_config {
    log_actions = [
      "TRANSFORM"
    ]
    log_action_states = [
      "SUCCEEDED",
      "FAILED"
    ]
  }
  delete_protection = false
}
