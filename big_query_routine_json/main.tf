resource "google_bigquery_dataset" "test" {
	dataset_id = "dataset_id-${local.name_suffix}"
}

resource "google_bigquery_routine" "sproc" {
  dataset_id = google_bigquery_dataset.test.dataset_id
  routine_id     = "routine_id-${local.name_suffix}"
  routine_type = "SCALAR_FUNCTION"
  language = "JAVASCRIPT"
  definition_body = "CREATE FUNCTION multiplyInputs return x*y;"
  arguments {
    name = "x"
    data_type = "{\"typeKind\" :  \"FLOAT64\"}"
  } 
  arguments {
    name = "y"
    data_type = "{\"typeKind\" :  \"FLOAT64\"}"
  }
   
  return_type = "{\"typeKind\" :  \"FLOAT64\"}"
}
