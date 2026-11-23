resource "google_design_center_application_template" "example" {
  project                 = "my-project-name"
  location                = "us-central1"
  space                   = "example-space"
  application_template_id = "example-full-template-${local.name_suffix}"
  display_name            = "Example Application Template"
  description             = "Managed by Terraform"
  composition_type        = "COMPOSITE"

  application_parameters {
    key   = "project_id"
    value = jsonencode("my-project-name")
  }

  application_parameters {
    key   = "region"
    value = jsonencode("us-central1")
  }

  saas_runtime_context {
    saas_names = [
      "projects/my-project-name/locations/us-central1/saas/example-saas",
    ]
  }
}
