data "google_project" "project" {}

resource "google_discovery_engine_data_store" "bigquery" {
  location                     = "global"
  data_store_id                = "data-store-id-${local.name_suffix}"
  display_name                 = "tf-test-datastore-doc-import-bq"
  industry_vertical            = "GENERIC"
  content_config               = "NO_CONTENT"
  solution_types               = ["SOLUTION_TYPE_SEARCH"]
  create_advanced_site_search  = false
  skip_default_schema_creation = false
}

resource "google_storage_bucket" "staging_bucket" {
  name                        = "import-bq-staging-${local.name_suffix}"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "discoveryengine_storage_access" {
  bucket     = google_storage_bucket.staging_bucket.name
  role       = "roles/storage.admin"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-discoveryengine.iam.gserviceaccount.com"
  depends_on = [google_discovery_engine_data_store.bigquery]
}

resource "google_storage_bucket_object" "bq_seed" {
  name    = "seed/bq_documents.jsonl"
  bucket  = google_storage_bucket.staging_bucket.name
  content = <<-EOT
    {"doc_id":"bq-doc-1","title":"BigQuery Document 1"}
    {"doc_id":"bq-doc-2","title":"BigQuery Document 2"}
  EOT
}

resource "google_bigquery_dataset" "import_dataset" {
  dataset_id                 = "import_dataset-${local.name_suffix}"
  location                   = "US"
  delete_contents_on_destroy = true
}

resource "google_bigquery_dataset_iam_member" "discoveryengine_bq_access" {
  dataset_id = google_bigquery_dataset.import_dataset.dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-discoveryengine.iam.gserviceaccount.com"
  depends_on = [google_discovery_engine_data_store.bigquery]
}

resource "google_bigquery_table" "import_table" {
  dataset_id          = google_bigquery_dataset.import_dataset.dataset_id
  table_id            = "import_table-${local.name_suffix}"
  deletion_protection = false

  time_partitioning {
    type = "DAY"
  }

  schema = jsonencode([
    {
      name = "doc_id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "title"
      type = "STRING"
      mode = "NULLABLE"
    }
  ])
}

resource "google_bigquery_job" "load_partition" {
  job_id   = "insert-bq-docs-${local.name_suffix}"
  location = "US"

  load {
    source_uris = [
      "gs://${google_storage_bucket.staging_bucket.name}/${google_storage_bucket_object.bq_seed.name}"
    ]
    source_format     = "NEWLINE_DELIMITED_JSON"
    write_disposition = "WRITE_TRUNCATE"

    destination_table {
      project_id = google_bigquery_table.import_table.project
      dataset_id = google_bigquery_table.import_table.dataset_id
      table_id   = "${google_bigquery_table.import_table.table_id}$20261026"
    }
  }
}

resource "google_discovery_engine_document_import" "bigquery" {
  location            = google_discovery_engine_data_store.bigquery.location
  collection_id       = "default_collection"
  data_store_id       = google_discovery_engine_data_store.bigquery.data_store_id
  branch_id           = "default_branch"
  import_id           = "bq-import-${local.name_suffix}"
  reconciliation_mode = "INCREMENTAL"
  auto_generate_ids   = false
  id_field            = "doc_id"

  bigquery_source {
    project_id      = data.google_project.project.project_id
    dataset_id      = google_bigquery_dataset.import_dataset.dataset_id
    table_id        = google_bigquery_table.import_table.table_id
    gcs_staging_dir = "gs://${google_storage_bucket.staging_bucket.name}/staging"
    data_schema     = "custom"

    partition_date {
      year  = 2026
      month = 10
      day   = 26
    }
  }

  error_config {
    gcs_prefix = "gs://${google_storage_bucket.staging_bucket.name}/errors"
  }

  depends_on = [
    google_storage_bucket_iam_member.discoveryengine_storage_access,
    google_bigquery_dataset_iam_member.discoveryengine_bq_access,
    google_bigquery_job.load_partition,
  ]
}
