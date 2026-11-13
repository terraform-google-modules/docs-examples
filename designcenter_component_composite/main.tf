resource "google_design_center_component" "example" {
  project                           = "my-project-name"
  location                          = "us-central1"
  space                             = "my-space"
  application_template              = "my-composite-application-template"
  component_id                      = "example-composite-component-${local.name_suffix}"
  display_name                      = "Example Composite Component"
  application_template_revision_uri = "projects/my-project-name/locations/us-central1/spaces/my-space/applicationTemplates/my-application-template/revisions/r-1"
  use_as_root_module                = true
}
