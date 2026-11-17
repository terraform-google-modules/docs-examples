resource "google_dataproc_batch" "example_batch_sparsql" {

    batch_id      = "tf-test-batch%{random_suffix}"
    location      = "us-east1"

    runtime_config {
      properties    = { "spark.dynamicAllocation.enabled": "false", "spark.executor.instances": "2" }
    }

    environment_config {
      execution_config {
        subnetwork_uri = "default-${local.name_suffix}"
      }
    }

    spark_sql_batch {
      query_file_uri   = "gs://dataproc-examples/spark-sql/natality/cigarette_correlations.sql"
      jar_file_uris    = ["file:///usr/lib/spark/examples/jars/spark-examples.jar"]
      query_variables  = {
        name = "value"
      }
    }
}
