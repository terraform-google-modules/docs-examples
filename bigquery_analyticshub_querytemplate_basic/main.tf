data "google_client_openid_userinfo" "me" {
}

resource "google_bigquery_analytics_hub_data_exchange" "querytemplate" {
  display_name = "My Audience Data Exchange"
  data_exchange_id = "my_data_exchange-${local.name_suffix}"
  description = "example of query template"
  location = "us"
  sharing_environment_config {
    dcr_exchange_config {}
  }
}

resource "google_bigquery_analytics_hub_query_template" "querytemplate" {
  location = "us"
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.querytemplate.data_exchange_id
  query_template_id = "my_query_template-${local.name_suffix}"
  display_name = "my_query_template-${local.name_suffix}"
  description = "example of query template"
  primary_contact   = data.google_client_openid_userinfo.me.email
  documentation = "This TVF takes a table t1 as input and returns all columns. Useful for basic data pass-through."
  routine {
    routine_type="TABLE_VALUED_FUNCTION"
    definition_body="my_query_template-${local.name_suffix}() as (select * from t1)"
  }
  submit=false
}
