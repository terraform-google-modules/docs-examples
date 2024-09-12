resource "google_secret_manager_regional_secret" "regional-secret-with-expire-time" {
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

  expire_time = "2055-11-30T00:00:00Z-${local.name_suffix}"
}
