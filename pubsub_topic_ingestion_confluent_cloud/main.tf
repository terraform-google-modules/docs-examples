resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"

  # Outside of automated terraform-provider-google CI tests, these values must be of actual Confluent Cloud resources for the test to pass.
  ingestion_data_source_settings {
    confluent_cloud {
        bootstrap_server = "test.us-west2.gcp.confluent.cloud:1111"
        cluster_id = "1234"
        topic = "test-topic"
        identity_pool_id = "test-identity-pool-id"
        gcp_service_account = "fake-service-account@fake-gcp-project.iam.gserviceaccount.com"
    }
  }
}
