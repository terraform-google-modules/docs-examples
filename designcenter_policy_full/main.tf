data "google_project" "project" {
  project_id = "my-project-name"
}

resource "google_design_center_policy" "example" {
  project              = "my-project-name"
  location             = "us-central1"
  space                = "example-space"
  application_template = "example-template"
  policy_id            = "example-policy-${local.name_suffix}"
  display_name         = "Example Policy"
  description          = "Managed by Terraform"
  policy_type          = "COMPLIANCE_FRAMEWORK"
  policy_uri           = "projects/${data.google_project.project.number}/locations/global/frameworks/builtin-us-data-boundary"

  apply_conditions {
    condition_key   = "environment"
    condition_value = "PRODUCTION"
  }

  apply_conditions {
    condition_key   = "criticality"
    condition_value = "HIGH"
  }
}
