resource "google_design_center_application_template" "example" {
  project                         = "my-project-name"
  location                        = "us-central1"
  space                           = "example-space"
  application_template_id         = "example-std-template-${local.name_suffix}"
  display_name                    = "Standard Application Template"
  description                     = "Managed by Terraform"
  inputs_as_root_module_variables = true
}
