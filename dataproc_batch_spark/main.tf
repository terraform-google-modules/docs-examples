resource "google_dataproc_batch" "example_batch_spark" {

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

    spark_batch {
      main_class    = "org.apache.spark.examples.SparkPi"
      args          = ["10"]
      jar_file_uris = ["file:///usr/lib/spark/examples/jars/spark-examples.jar"]
    }
}
