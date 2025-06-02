resource "google_storage_bucket" "bucket" {
  name     = "tf-sample-bucket-${local.name_suffix}"
  location = "us-central1"
  force_destroy = true
}

resource "google_storage_batch_operations_job" "tf-job" {
	job_id     = "tf-job-${local.name_suffix}"
	bucket_list {
		buckets  {
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
			"key"="value"
		}
	}
	delete_protection = false
}
