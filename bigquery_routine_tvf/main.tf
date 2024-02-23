resource "google_bigquery_dataset" "test" {
	dataset_id = "dataset_id-${local.name_suffix}"
}

resource "google_bigquery_routine" "sproc" {
  dataset_id      = google_bigquery_dataset.test.dataset_id
  routine_id      = "routine_id-${local.name_suffix}"
  routine_type    = "TABLE_VALUED_FUNCTION"
  language        = "SQL"
  definition_body = <<-EOS
    SELECT 1 + value AS value
  EOS
  arguments {
    name          = "value"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "INT64" })
  }
  return_table_type = jsonencode({"columns" : [
    { "name" : "value", "type" : { "typeKind" : "INT64" } },
  ] })
}
