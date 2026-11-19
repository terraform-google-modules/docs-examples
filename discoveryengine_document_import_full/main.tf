data "google_project" "project" {}

resource "google_discovery_engine_data_store" "full" {
  location                     = "global"
  data_store_id                = "data-store-id-${local.name_suffix}"
  display_name                 = "tf-test-datastore-doc-import-full"
  industry_vertical            = "GENERIC"
  content_config               = "NO_CONTENT"
  solution_types               = ["SOLUTION_TYPE_SEARCH"]
  create_advanced_site_search  = false
  skip_default_schema_creation = false
}

resource "google_storage_bucket" "import_bucket" {
  name                        = "import-bucket-full-${local.name_suffix}"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "discoveryengine_access" {
  bucket     = google_storage_bucket.import_bucket.name
  role       = "roles/storage.admin"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-discoveryengine.iam.gserviceaccount.com"
  depends_on = [google_discovery_engine_data_store.full]
}

resource "google_storage_bucket_object" "documents" {
  name    = "documents.jsonl"
  bucket  = google_storage_bucket.import_bucket.name
  content = <<-EOT
    {"doc_id":"doc-1","title":"Full Import Document 1"}
    {"doc_id":"doc-2","title":"Full Import Document 2"}
  EOT
}

resource "google_discovery_engine_document_import" "full" {
  location              = google_discovery_engine_data_store.full.location
  collection_id         = "default_collection"
  data_store_id         = google_discovery_engine_data_store.full.data_store_id
  branch_id             = "default_branch"
  import_id             = "full-import-${local.name_suffix}"
  reconciliation_mode   = "FULL"
  auto_generate_ids     = false
  id_field              = "doc_id"
  force_refresh_content = true
  deletion_policy       = "DELETE"

  gcs_source {
    input_uris  = ["gs://${google_storage_bucket.import_bucket.name}/${google_storage_bucket_object.documents.name}"]
    data_schema = "custom"
  }

  error_config {
    gcs_prefix = "gs://${google_storage_bucket.import_bucket.name}/errors"
  }

  depends_on = [google_storage_bucket_iam_member.discoveryengine_access]
}
