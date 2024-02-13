resource "google_clouddeploy_custom_target_type" "custom-target-type" {
    location = "us-central1"
    name = "my-custom-target-type-${local.name_suffix}"
    description = "My custom target type"
    custom_actions {
      render_action = "renderAction"
      deploy_action = "deployAction"
      include_skaffold_modules {
        configs = ["my-config"]
        git {
            repo = "http://github.com/example/example-repo.git"
            path = "configs/skaffold.yaml"
            ref = "main"
        }
      }
    }
}
