resource "google_storage_bucket" "bucket" {
  name                        = "bucket-${local.name_suffix}"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket" "second_bucket" {
  name                        = "bucket-2-${local.name_suffix}"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_control_project_feature_config" "example" {
  feature_config_id = "feature-config-${local.name_suffix}"
  description       = "Annotates images in two buckets"

  filter {
    included_cloud_storage_buckets {
      bucket_id_regexes = [
        google_storage_bucket.bucket.name,
        google_storage_bucket.second_bucket.name,
      ]
    }
  }

  auto_annotate_config {
    models {
      name = "face-detector"
    }
    models {
      name = "content-safety"
    }
    processing_location = "eu"
  }
}
