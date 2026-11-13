resource "google_design_center_application" "example" {
  project            = "my-project-name"
  location           = "us-central1"
  space              = "example-space"
  application_id     = "example-full-application-${local.name_suffix}"
  display_name       = "Example Application"
  description        = "Managed by Terraform"
  deployment_region  = "us-central1"
  deployment_project = "my-project-name"
  service_account    = "projects/my-project-name/serviceAccounts/deployer@my-project-name.iam.gserviceaccount.com"

  source {
    application_template_revision = "projects/my-project-name/locations/us-central1/spaces/example-space/applicationTemplates/example-template/revisions/r-1"
  }

  scope {
    type = "REGIONAL"
  }

  app_parameters {
    key   = "project_id"
    value = jsonencode("my-project-name")
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

  deployment_target {
    gke_deployment_target {
      cluster_self_link                   = "projects/my-project-name/locations/us-central1/clusters/example-cluster"
      namespace                           = "example-namespace"
      kubernetes_service_account          = "default"
      kubernetes_service_account_creation = true
    }
  }
}
