resource "google_clouddeploy_deploy_policy" "b-deploy-policy" {
  name     = "cd-policy-${local.name_suffix}"
  location = "us-central1"
  selectors {
    delivery_pipeline {
      id = "cd-pipeline-${local.name_suffix}"
    }
  }
  rules {
    rollout_restriction {
      id = "rule"
      time_windows {
        time_zone = "America/Los_Angeles"
        weekly_windows {
            start_time {
                hours = "12"
                minutes = "00"
            }
            end_time {
                hours = "13"
                minutes = "00"
            }
        }
      }
    }
  }
}
