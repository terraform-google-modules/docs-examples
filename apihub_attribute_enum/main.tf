resource "google_apihub_attribute" "default" {
  location     = "us-central1"
  attribute_id = "example-enum-attribute-${local.name_suffix}"
  display_name = "Example Enum Attribute"
  description  = "Initial enum attribute description"
  scope        = "VERSION"
  data_type    = "ENUM"

  allowed_values {
    id           = "value-1"
    display_name = "Value 1"
    description  = "First allowed value"
  }

  allowed_values {
    id           = "value-2"
    display_name = "Value 2"
  }

  allowed_values {
    id           = "value-3"
    display_name = "Value 3"
  }
}
