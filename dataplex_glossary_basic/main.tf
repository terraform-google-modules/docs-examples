resource "google_dataplex_glossary" "glossary_test_id" {
  glossary_id = "glossary-basic-${local.name_suffix}"
  location = "us-central1"
}
