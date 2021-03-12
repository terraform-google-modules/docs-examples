
resource "google_healthcare_dataset" "dataset" {
  location = "us-central1"
  name     = "my-dataset-${local.name_suffix}"
}

resource "google_healthcare_consent_store" "my-consent" {
  dataset = google_healthcare_dataset.dataset.id
  name    = "my-consent-store-${local.name_suffix}"

  enable_consent_create_on_update = true
  default_consent_ttl             = "90000s"

  labels = {
    "label1" = "labelvalue1"
  }
}
