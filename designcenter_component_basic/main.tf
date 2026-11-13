resource "google_design_center_component" "example" {
  project                      = "my-project-name"
  location                     = "us-central1"
  space                        = "my-space"
  application_template         = "my-application-template"
  component_id                 = "example-component-${local.name_suffix}"
  display_name                 = "Example Component"
  shared_template_revision_uri = "projects/gcpdesigncenter/locations/us-central1/spaces/googlespace/sharedTemplates/1b5e09c8-780f-484e-b8ed-c7178f4e4342/revisions/r-24"

  parameters {
    key   = "service_name"
    value = jsonencode("example-service")
  }

  parameters {
    key   = "location"
    value = jsonencode("us-central1")
  }
}
