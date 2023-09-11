resource "google_secret_manager_secret" "secret-with-annotations" {
  secret_id = "secret-${local.name_suffix}"

  labels = {
    label = "my-label"
  }

  annotations = {
    key1 = "someval"
    key2 = "someval2"
    key3 = "someval3"
    key4 = "someval4"
    key5 = "someval5"
  }

  replication {
    auto {}
  }
}
