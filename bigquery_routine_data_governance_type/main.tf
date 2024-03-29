resource "google_bigquery_dataset" "test" {
	dataset_id = "tf_test_dataset_id%{random_suffix}"
}

resource "google_bigquery_routine" "custom_masking_routine" {
	dataset_id = google_bigquery_dataset.test.dataset_id
	routine_id     = "custom_masking_routine"
	routine_type = "SCALAR_FUNCTION"
	language = "SQL"
	data_governance_type = "DATA_MASKING"
	definition_body = "SAFE.REGEXP_REPLACE(ssn, '[0-9]', 'X')"
	arguments {
	  name = "ssn"
	  data_type = "{\"typeKind\" :  \"STRING\"}"
	} 
	return_type = "{\"typeKind\" :  \"STRING\"}"
  }
  
