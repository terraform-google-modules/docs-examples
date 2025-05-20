resource "google_dataplex_glossary" "glossary_test_id_full" {
  glossary_id = "glossary-full-${local.name_suffix}"
  location     = "us-central1"

  labels = { "tag": "test-tf" }
  display_name = "terraform glossary"
  description = "glossary created by Terraform"
}
