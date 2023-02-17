resource "google_document_ai_processor" "processor" {
  location = "us"
  display_name = "test-processor-${local.name_suffix}"
  type = "OCR_PROCESSOR"
}

resource "google_document_ai_processor_default_version" "processor" {
  processor = google_document_ai_processor.processor.id
  version = "${google_document_ai_processor.processor.id}/processorVersions/stable"

  lifecycle {
    ignore_changes = [
      # Using "stable" or "rc" will return a specific version from the API; suppressing the diff.
      version,
    ]
  }
}
