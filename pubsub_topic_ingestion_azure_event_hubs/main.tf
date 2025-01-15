resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"

  # Outside of automated terraform-provider-google CI tests, these values must be of actual Azure resources for the test to pass.
  ingestion_data_source_settings {
    azure_event_hubs {
        resource_group = "azure-ingestion-resource-group"
        namespace = "azure-ingestion-namespace"
        event_hub = "azure-ingestion-event-hub"
        client_id = "aZZZZZZZ-YYYY-HHHH-GGGG-abcdef569123"
        tenant_id = "0XXXXXXX-YYYY-HHHH-GGGG-123456789123"
        subscription_id = "bXXXXXXX-YYYY-HHHH-GGGG-123456789123"
        gcp_service_account = "fake-service-account@fake-gcp-project.iam.gserviceaccount.com"
    }
  }
}
