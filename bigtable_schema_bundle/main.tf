resource "google_bigtable_instance" "instance" {
  name = "bt-instance-${local.name_suffix}"
  cluster {
    cluster_id   = "cluster-1"
    zone         = "us-east1-b"
    num_nodes    = 1
    storage_type = "HDD"
  }

  deletion_protection  = false
}

resource "google_bigtable_table" "table" {
  name          = "bt-table-${local.name_suffix}"
  instance_name = google_bigtable_instance.instance.name

  column_family {
	family = "CF"
  }
}

resource "google_bigtable_schema_bundle" "schema_bundle" {
  schema_bundle_id = "bt-schema-bundle-${local.name_suffix}"
  instance         = google_bigtable_instance.instance.name
  table            = google_bigtable_table.table.name

  proto_schema {
    proto_descriptors = filebase64("test-fixtures/proto_schema_bundle.pb")
  }
}
