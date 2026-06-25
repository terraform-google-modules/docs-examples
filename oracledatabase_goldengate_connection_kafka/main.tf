resource "google_oracle_database_goldengate_connection" "connection" {
  goldengate_connection_id = "my-connection-${local.name_suffix}"
  location                 = "europe-west8"
  project                  = "my-project-${local.name_suffix}"
  gcp_oracle_zone          = "europe-west8-a-r1"

  properties {
    display_name    = "my-connection-${local.name_suffix} display name"
    connection_type = "KAFKA"
    kafka_connection_properties {
      technology_type              = "APACHE_KAFKA"
      stream_pool_id               = "ocid1.streampool.oc1..example"
      cluster_id                   = "ocid1.kafkacluster.oc1..example"
      bootstrap_servers {
        host               = "kafka.example.com"
        port               = 9092
        private_ip_address = "10.0.0.1"
      }
      security_protocol            = "SSL"
      consumer_properties_file     = "Y29uc3VtZXIucHJvcGVydGllcz1kZW1v"
      producer_properties_file     = "cHJvZHVjZXIucHJvcGVydGllcz1kZW1v"
      use_resource_principal       = false
    }
  }
  deletion_protection = "true-${local.name_suffix}"
}
