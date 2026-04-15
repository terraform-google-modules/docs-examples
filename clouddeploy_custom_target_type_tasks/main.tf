resource "google_clouddeploy_custom_target_type" "custom-target-type" {
  location    = "us-central1"
  name        = "my-custom-target-type-${local.name_suffix}"
  description = "My custom target type"

  tasks {
    render {
      container {
        image = "gcr.io/my-project/my-render-image"
      }
    }
    deploy {
      container {
        image = "gcr.io/my-project/my-deploy-image"
      }
    }
  }
}
