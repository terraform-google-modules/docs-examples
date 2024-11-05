// App Engine Example
resource "google_compute_region_network_endpoint_group" "appengine_neg" {
  name                  = "appengine-neg-${local.name_suffix}"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  app_engine {
    service = google_app_engine_flexible_app_version.appengine_neg.service
    version = google_app_engine_flexible_app_version.appengine_neg.version_id
  }
}

resource "google_app_engine_flexible_app_version" "appengine_neg" {
  version_id = "v1"
  service    = "appengine-neg-${local.name_suffix}"
  runtime    = "nodejs"
  flexible_runtime_settings {
    operating_system = "ubuntu22"
    runtime_version = "20"
  }

  entrypoint {
    shell = "node ./app.js"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.appengine_neg.name}/${google_storage_bucket_object.appengine_neg.name}"
    }
  }

  liveness_check {
    path = "/"
  }

  readiness_check {
    path = "/"
  }

  env_variables = {
    port = "8080"
  }

  handlers {
    url_regex        = ".*\\/my-path\\/*"
    security_level   = "SECURE_ALWAYS"
    login            = "LOGIN_REQUIRED"
    auth_fail_action = "AUTH_FAIL_ACTION_REDIRECT"

    static_files {
      path = "my-other-path"
      upload_path_regex = ".*\\/my-path\\/*"
    }
  }

  automatic_scaling {
    cool_down_period = "120s"
    cpu_utilization {
      target_utilization = 0.5
    }
  }

  delete_service_on_destroy = true
}

resource "google_storage_bucket" "appengine_neg" {
  name     = "appengine-neg-${local.name_suffix}"
  location = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "appengine_neg" {
  name   = "hello-world.zip"
  bucket = google_storage_bucket.appengine_neg.name
  source = "./test-fixtures/hello-world.zip"
}
