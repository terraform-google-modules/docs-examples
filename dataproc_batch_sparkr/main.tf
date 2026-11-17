resource "google_dataproc_batch" "example_batch_sparkr" {

    batch_id      = "tf-test-batch%{random_suffix}"
    location      = "us-east1"
    labels        = {"batch_test": "terraform"}

    runtime_config {
      properties    = { "spark.dynamicAllocation.enabled": "false", "spark.executor.instances": "2" }
    }

    environment_config {
      execution_config {
        subnetwork_uri = "default-${local.name_suffix}"
        ttl            = "3600s"
        network_tags   = ["tag1"]
      }
    }

    spark_r_batch {
      main_r_file_uri  = "https://storage.googleapis.com/terraform-serverless/spark-r-flights.r"
      args             = ["https://storage.googleapis.com/terraform-serverless/flights.csv"]
    }
}
