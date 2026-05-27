resource "google_oracle_database_goldengate_connection_assignment" "assignment" {
  goldengate_connection_assignment_id = "my-assignment-${local.name_suffix}"
  display_name                        = "my-assignment-${local.name_suffix}"
  location                            = "us-east4"
  project                             = "my-project-${local.name_suffix}"
  labels = {
    "label-one" = "value-one"
  }

  properties {
    goldengate_connection = "projects/my-project-${local.name_suffix}/locations/us-east4/goldengateConnections/my-connection-${local.name_suffix}"
    goldengate_deployment = "projects/my-project-${local.name_suffix}/locations/us-east4/goldengateDeployments/my-deployment-${local.name_suffix}"
  }
  deletion_protection = "true-${local.name_suffix}"
}


