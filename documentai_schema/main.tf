resource "google_document_ai_schema" "schema" {
  location     = "us"
  display_name = "my-schema-${local.name_suffix}"
  labels = {
    "env" = "test"
  }
}
