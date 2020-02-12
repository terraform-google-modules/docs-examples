resource "google_datastore_index" "default" {
  kind = "foo"
  properties {
    name = "property_a-${local.name_suffix}"
    direction = "ASCENDING"
  }
  properties {
    name = "property_b-${local.name_suffix}"
    direction = "ASCENDING"
  }
}
