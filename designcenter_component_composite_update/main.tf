resource "google_design_center_component" "example" {
  project                           = "my-project-name"
  location                          = "us-central1"
  space                             = "my-space"
  application_template              = "my-composite-application-template"
  component_id                      = "example-composite-component-${local.name_suffix}"
  display_name                      = "Updated Example Composite Component"
  application_template_revision_uri = "projects/my-project-name/locations/us-central1/spaces/my-space/applicationTemplates/my-application-template/revisions/r-1"
  use_as_root_module                = false

  application_info {
    apphub_application_id = "example-apphub-application"
    display_name          = "Example App Hub Application"
    deployment_region     = "us-central1"

    scope {
      type = "REGIONAL"
    }

    attributes {
      criticality {
        type = "HIGH"
      }

      environment {
        type = "STAGING"
      }

      developer_owners {
        display_name = "Example Developer"
        email        = "developer@example.com"
      }

      operator_owners {
        display_name = "Example Operator"
        email        = "operator@example.com"
      }

      business_owners {
        display_name = "Example Business Owner"
        email        = "business@example.com"
      }
    }
  }
}
