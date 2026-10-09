resource "google_document_ai_schema" "schema" {
  location     = "us"
  display_name = "my-schema-${local.name_suffix}"
  labels = {
    "env" = "test"
  }
}

resource "google_document_ai_schema_version" "schema_version" {
  location     = "us"
  schema_id    = google_document_ai_schema.schema.name
  display_name = "my-schema-version"
  labels = {
    "env" = "test"
  }
  schema {
    display_name    = "test-doc-schema"
    description     = "Schema description"
    document_prompt = "Document prompt text"
    metadata {
      document_splitter              = true
      document_allow_multiple_labels = true
      prefixed_naming_on_properties  = false
      skip_naming_validation         = true
    }
    entity_types {
      name         = "document"
      display_name = "Document Root"
      base_types   = ["document"]
      properties {
        name            = "invoice_id"
        display_name    = "Invoice ID"
        value_type      = "invoice_id"
        occurrence_type = "OPTIONAL_ONCE"
        method          = "EXTRACT"
      }
      properties {
        name            = "payment_type"
        display_name    = "Payment Type"
        value_type      = "payment_type"
        occurrence_type = "OPTIONAL_MULTIPLE"
        method          = "DERIVE"
      }
    }
    entity_types {
      name         = "invoice_id"
      display_name = "Invoice ID"
      base_types   = ["string"]
    }
    entity_types {
      name         = "payment_type"
      display_name = "Payment Type"
      base_types   = ["string"]
      enum_values {
        values = ["CREDIT_CARD", "DEBIT_CARD", "WIRE"]
      }
    }
  }
}
