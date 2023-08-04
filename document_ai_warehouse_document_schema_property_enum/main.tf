resource "google_document_ai_warehouse_document_schema" "example_property_enum" {
  project_number     = data.google_project.project.number
  display_name       = "test-property-property"
  location           = "us"
  document_is_folder = false

  property_definitions {
    name                 = "prop8"
    display_name         = "propdisp8"
    is_repeatable        = false
    is_filterable        = true
    is_searchable        = true
    is_metadata          = false
    is_required          = false
    retrieval_importance = "HIGHEST"
    schema_sources {
      name           = "dummy_source"
      processor_type = "dummy_processor"
    }
    property_type_options {
      property_definitions {
        name                 = "prop8_nested"
        display_name         = "propdisp8_nested"
        is_repeatable        = false
        is_filterable        = true
        is_searchable        = true
        is_metadata          = false
        is_required          = false
        retrieval_importance = "HIGHEST"
        schema_sources {
          name           = "dummy_source_nested"
          processor_type = "dummy_processor_nested"
        }
        enum_type_options {
          possible_values = [
            "M",
            "F",
            "X"
          ]
          validation_check_disabled = false
        }
      }
    }
  }
}

data "google_project" "project" {
}
