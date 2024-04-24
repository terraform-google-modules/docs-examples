resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-${local.name_suffix}"
  location = "us-central1"
  launch_stage = "GA"
  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
    vpc_access{
      network_interfaces {
        network = "default"
        subnetwork = "default"
        tags = ["tag1", "tag2", "tag3"]
      }
      egress = "ALL_TRAFFIC"
    }
  }
}
