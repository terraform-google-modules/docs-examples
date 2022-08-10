# Example of using a public Cloud Run service to call a private one

resource "google_cloud_run_service" "default" {
  name     = "public-service-${local.name_suffix}"
  location = "us-central1"

  template {
    spec {
      containers {
        # TODO<developer>: replace this with a public service container
        # (This service can be invoked by anyone on the internet)
        image = "us-docker.pkg.dev/cloudrun/container/hello"

        # Include a reference to the private Cloud Run
        # service's URL as an environment variable.
        env {
          name = "URL"
          value = google_cloud_run_service.default_private.status[0].url
        }
      }

      # Give the "public" Cloud Run service
      # a service account's identity
      service_account_name = google_service_account.default.email
    }
  }
}

data "google_iam_policy" "public" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "public" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.public.policy_data
}

resource "google_service_account" "default" {
  account_id   = "cloud-run-interservice-id"
  description  = "Identity used by a public Cloud Run service to call private Cloud Run services."
  display_name = "cloud-run-interservice-id"
}

resource "google_cloud_run_service" "default_private" {
  name     = "private-service-${local.name_suffix}"
  location = "us-central1"

  template {
    spec {
      containers {
        // TODO<developer>: replace this with a private service container
        // (This service should only be invocable by the public service)
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }
}

data "google_iam_policy" "private" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${google_service_account.default.email}",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "private" {
  location    = google_cloud_run_service.default_private.location
  project     = google_cloud_run_service.default_private.project
  service     = google_cloud_run_service.default_private.name

  policy_data = data.google_iam_policy.private.policy_data
}
