resource "google_document_ai_processor" "processor" {
  location = "eu"
  display_name = "test-processor-${local.name_suffix}"
  type = "OCR_PROCESSOR"
}
