resource "google_bigquery_datapolicyv2_data_policy" "data_policy_with_grantees" {
  location         = "us-central1"
  data_policy_type = "RAW_DATA_ACCESS_POLICY"
  grantees = [
    "principalSet://goog/group/bigquery-datamasking-swe@google.com"
  ]
  data_policy_id   = "data_policy_with_grantees-${local.name_suffix}"
}
