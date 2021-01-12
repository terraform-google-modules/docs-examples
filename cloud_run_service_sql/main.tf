resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv-${local.name_suffix}"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1000"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.instance.connection_name
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
  autogenerate_revision_name = true
}

resource "google_sql_database_instance" "instance" {
  name   = "cloudrun-sql-${local.name_suffix}"
  region = "us-east1"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection  = "false"
}
