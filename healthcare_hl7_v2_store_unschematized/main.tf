resource "google_healthcare_hl7_v2_store" "store" {
  provider = google-beta
  name    = "example-hl7-v2-store-${local.name_suffix}"
  dataset = google_healthcare_dataset.dataset.id

  parser_config {
    allow_null_header  = false
    segment_terminator = "Jw=="
    version            = "V2"
  }
}

resource "google_healthcare_dataset" "dataset" {
  provider = google-beta
  name     = "example-dataset-${local.name_suffix}"
  location = "us-central1"
}
