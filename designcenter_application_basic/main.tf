resource "google_design_center_application" "example" {
  project           = "my-project-name"
  location          = "us-central1"
  space             = "example-space"
  application_id    = "example-application-${local.name_suffix}"
  deployment_region = "us-central1"

  source {
    application_template_revision = "projects/my-project-name/locations/us-central1/spaces/example-space/applicationTemplates/example-template/revisions/r-1"
  }

  scope {
    type = "REGIONAL"
  }
}
