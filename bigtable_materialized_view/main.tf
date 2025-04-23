resource "google_bigtable_instance" "instance" {
  name = "bt-instance-${local.name_suffix}"
  cluster {
    cluster_id   = "cluster-1"
    zone         = "us-east1-b"
    num_nodes    = 3
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

resource "google_bigtable_materialized_view" "materialized_view" {
  materialized_view_id = "bt-materialized-view-${local.name_suffix}"
  instance             = google_bigtable_instance.instance.name
  deletion_protection  = false
  query = <<EOT
SELECT _key, COUNT(CF['col1']) as Count
FROM ` + "`bt-table-${local.name_suffix}`" + `
GROUP BY _key
EOT

  depends_on = [
    google_bigtable_table.table
  ]
}
