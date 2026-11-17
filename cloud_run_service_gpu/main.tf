resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv-${local.name_suffix}"
  location = "us-central1"


  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale": "1"
        "run.googleapis.com/cpu-throttling": "false"
        # Explicitly disable zonal redundancy to bypass quota limits in the HashiCorp test project.
        # Alternatively, if quota is granted to the test project, this annotation can be removed 
        # to properly test the DiffSuppressFunc.
        "run.googleapis.com/gpu-zonal-redundancy-disabled": "true"
      }
    }
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
        resources {
          limits = {
            "cpu" = "4"
            "memory" = "16Gi"
            "nvidia.com/gpu" = "1"
          }
        }
      }
      node_selector = {
        "run.googleapis.com/accelerator" = "nvidia-l4"
      }
    }
  }
}
