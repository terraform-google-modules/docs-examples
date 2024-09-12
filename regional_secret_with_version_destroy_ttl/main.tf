resource "google_secret_manager_regional_secret" "regional-secret-with-version-destroy-ttl" {
  secret_id = "tf-reg-secret-${local.name_suffix}"
  location = "us-central1"

  labels = {
    label = "my-label"
  }

  annotations = {
    key1 = "value1",
    key2 = "value2",
    key3 = "value3"
  }

  version_destroy_ttl = "86400s"
}
