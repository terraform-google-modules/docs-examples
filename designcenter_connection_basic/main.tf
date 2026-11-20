resource "google_design_center_connection" "example" {
  project                   = "my-project-name"
  location                  = "us-central1"
  space                     = "my-space"
  application_template      = "my-application-template"
  component                 = "my-source-component"
  connection_id             = "example-connection-${local.name_suffix}"
  destination_component_uri = "projects/my-project-name/locations/us-central1/spaces/my-space/applicationTemplates/my-application-template/components/my-dest-component"
}
