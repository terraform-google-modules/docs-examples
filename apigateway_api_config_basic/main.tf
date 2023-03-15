resource "google_api_gateway_api" "api_cfg" {
  provider = google-beta
  api_id = "my-api-${local.name_suffix}"
}

resource "google_api_gateway_api_config" "api_cfg" {
  provider = google-beta
  api = google_api_gateway_api.api_cfg.api_id
  api_config_id = "my-config-${local.name_suffix}"

  openapi_documents {
    document {
      path = "spec.yaml"
      contents = filebase64("test-fixtures/apigateway/openapi.yaml")
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
