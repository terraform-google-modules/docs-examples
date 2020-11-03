resource "google_game_services_game_server_deployment" "default" {
  deployment_id  = "tf-test-deployment-${local.name_suffix}"
  description = "a deployment description"
}

resource "google_game_services_game_server_config" "default" {
  config_id     = "tf-test-config-${local.name_suffix}"
  deployment_id = google_game_services_game_server_deployment.default.deployment_id
  description   = "a config description"

  fleet_configs {
    name       = "something-unique"
    fleet_spec = jsonencode({ "replicas" : 1, "scheduling" : "Packed", "template" : { "metadata" : { "name" : "tf-test-game-server-template" }, "spec" : { "ports": [{"name": "default", "portPolicy": "Dynamic", "containerPort": 7654, "protocol": "UDP"}], "template" : { "spec" : { "containers" : [{ "name" : "simple-udp-server", "image" : "gcr.io/agones-images/udp-server:0.14" }] } } } } })
  }

  scaling_configs {
    name = "scaling-config-name"
    fleet_autoscaler_spec = jsonencode({"policy": {"type": "Webhook","webhook": {"service": {"name": "autoscaler-webhook-service","namespace": "default","path": "scale"}}}})
    selectors {
      labels = {
        "one" : "two"
      }
    }

    schedules {
      cron_job_duration = "3.500s"
      cron_spec         = "0 0 * * 0"
    }
  }
}
