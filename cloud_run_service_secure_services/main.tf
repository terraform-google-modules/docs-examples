resource "google_cloud_run_service" "renderer" {
  provider = google-beta
  name     = "renderer-${local.name_suffix}"
  location = "us-central1"
  template {
    spec {
      containers {
        # Replace with the URL of your Secure Services > Renderer image.
        #   gcr.io/<PROJECT_ID>/renderer
        image = "gcr.io/cloudrun/hello"
      }
      service_account_name = google_service_account.renderer.email
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "editor" {
  provider = google-beta
  name     = "editor-${local.name_suffix}"
  location = "us-central1"
  template {
    spec {
      containers {
        # Replace with the URL of your Secure Services > Editor image.
        #   gcr.io/<PROJECT_ID>/editor
        image = "gcr.io/cloudrun/hello"
        env {
          name  = "EDITOR_UPSTREAM_RENDER_URL"
          value = google_cloud_run_service.renderer.status[0].url
        }
      }
      service_account_name = google_service_account.editor.email
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_service_account" "renderer" {
  provider     = google-beta
  account_id   = "renderer-identity"
  display_name = "Service identity of the Renderer (Backend) service."
}

resource "google_service_account" "editor" {
  provider     = google-beta
  account_id   = "editor-identity"
  display_name = "Service identity of the Editor (Frontend) service."
}

resource "google_cloud_run_service_iam_member" "editor_invokes_renderer" {
  provider = google-beta
  location = google_cloud_run_service.renderer.location
  service  = google_cloud_run_service.renderer.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.editor.email}"
}

data "google_iam_policy" "noauth" {
  provider = google-beta
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  provider = google-beta
  location = google_cloud_run_service.editor.location
  project  = google_cloud_run_service.editor.project
  service  = google_cloud_run_service.editor.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

output "backend_url" {
  value = google_cloud_run_service.renderer.status[0].url
}

output "frontend_url" {
  value = google_cloud_run_service.editor.status[0].url
}
