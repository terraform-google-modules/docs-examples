resource "google_bigquery_datapolicyv2_data_policy" "routine_data_policy" {
  location         = "us-central1"
  data_policy_id   = "routine_data_policy-${local.name_suffix}"
	data_policy_type = "DATA_MASKING_POLICY"  
	data_masking_policy {
		routine = google_bigquery_routine.custom_masking_routine.id
	}
}

resource "google_bigquery_dataset" "test" {
  dataset_id = "dataset_id-${local.name_suffix}"
  location   = "us-central1"
}

resource "google_bigquery_routine" "custom_masking_routine" {
	dataset_id           = google_bigquery_dataset.test.dataset_id
	routine_id           = "custom_masking_routine"
	routine_type         = "SCALAR_FUNCTION"
	language             = "SQL"
	data_governance_type = "DATA_MASKING"
	definition_body      = "SAFE.REGEXP_REPLACE(ssn, '[0-9]', 'X')"
	return_type          = "{\"typeKind\" :  \"STRING\"}"

	arguments {
	  name = "ssn"
	  data_type = "{\"typeKind\" :  \"STRING\"}"
	} 
}
