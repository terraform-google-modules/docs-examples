resource "google_game_services_game_server_deployment" "default" {
  deployment_id  = "tf-test-deployment-${local.name_suffix}"
  description = "a deployment description"
}
