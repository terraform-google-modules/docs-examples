resource "google_bigtable_instance" "example" {
  name = "example-bt-${local.name_suffix}"

  cluster {
    cluster_id = "example-bt-${local.name_suffix}"
    zone       = "us-central1-b"
    num_nodes  = 1
  }

  deletion_protection = false
}

resource "google_bigtable_app_profile" "example" {
  instance       = google_bigtable_instance.example.name
  app_profile_id = "example-profile-${local.name_suffix}"

  single_cluster_routing {
    cluster_id = "example-bt-${local.name_suffix}"
  }

  ignore_warnings = true
}

resource "google_bigtable_table" "example" {
  name          = "example-table-${local.name_suffix}"
  instance_name = google_bigtable_instance.example.name

  column_family {
    family = "data"
  }

  column_family {
    family = "pubsub_metadata"
  }
}

resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"
}

resource "google_pubsub_subscription" "example" {
  name  = "example-subscription-${local.name_suffix}"
  topic = google_pubsub_topic.example.id

  bigtable_config {
    table          = google_bigtable_table.example.id
    app_profile_id = google_bigtable_app_profile.example.app_profile_id
    write_metadata = true

    column_family_mapping {
      delimited_key {
        key_fields = ["user_id", "event_id"]
        # base64 encoding of "#"
        delimiter  = "Iw=="
      }
    }
  }
}
