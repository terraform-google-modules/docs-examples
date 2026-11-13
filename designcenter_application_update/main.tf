resource "google_design_center_application" "example" {
  project            = "my-project-name"
  location           = "us-central1"
  space              = "example-space"
  application_id     = "example-full-application-${local.name_suffix}"
  display_name       = "Updated Example Application"
  description        = "Updated Managed by Terraform"
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

  app_parameters {
    key   = "location"
    value = jsonencode("us-central1")
  }

  attributes {
    criticality {
      type = "MEDIUM"
    }

    environment {
      type = "TEST"
    }

    developer_owners {
      display_name = "Updated Example Developer"
      email        = "updated-developer@example.com"
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

  component_parameters {
    component = "projects/my-project-name/locations/us-central1/spaces/example-space/applicationTemplates/example-template/components/source-component"

    parameters {
      key   = "service_name"
      value = jsonencode("example-service")
    }

    parameters {
      key   = "project_id"
      value = jsonencode("my-project-name")
    }

    parameters {
      key   = "location"
      value = jsonencode("us-central1")
    }
  }

  component_parameters {
    component = "projects/my-project-name/locations/us-central1/spaces/example-space/applicationTemplates/example-template/components/destination-component"

    parameters {
      key   = "project_id"
      value = jsonencode("my-project-name")
    }

    parameters {
      key   = "region"
      value = jsonencode("us-central1")
    }
  }

  connection_configs {
    connection_uri = "projects/my-project-name/locations/us-central1/spaces/example-space/applicationTemplates/example-template/components/source-component/connections/example-connection"

    source_component_parameters {
      key   = "service_account_project_roles"
      value = jsonencode(["roles/cloudsql.client"])
    }

    destination_component_parameters {
      key = "iam_users"
      value = jsonencode([
        {
          id    = "example-sa"
          email = "example-sa@my-project-name.iam.gserviceaccount.com"
          type  = "CLOUD_IAM_SERVICE_ACCOUNT"
        },
      ])
    }
  }

  composite_application_parameters {
    service_account_map = {
      "projects/my-project-name/locations/us-central1/spaces/example-space/applicationTemplates/example-template/components/source-component" = "projects/my-project-name/serviceAccounts/deployer@my-project-name.iam.gserviceaccount.com"
    }
  }

  roles_apis_config {
    project_id = "my-project-name"

    roles {
      role = "roles/viewer"
    }

    apis {
      api = "logging.googleapis.com"
    }
  }
}
