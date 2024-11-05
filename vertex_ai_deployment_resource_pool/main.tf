resource "google_vertex_ai_deployment_resource_pool" "deployment_resource_pool" {
    region = "us-central1"
    name = "example-deployment-resource-pool-${local.name_suffix}"
    dedicated_resources {
        machine_spec {
            machine_type = "n1-standard-4"
            accelerator_type = "NVIDIA_TESLA_P4"
            accelerator_count = 1
        }

        min_replica_count = 1
        max_replica_count = 2

        autoscaling_metric_specs {
            metric_name = "aiplatform.googleapis.com/prediction/online/accelerator/duty_cycle"
            target = 60
        }
    }
}
