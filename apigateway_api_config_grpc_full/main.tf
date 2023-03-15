resource "google_api_gateway_api" "api_cfg" {
  provider = google-beta
  api_id = "my-api-${local.name_suffix}"
}

resource "google_api_gateway_api_config" "api_cfg" {
  provider = google-beta
  api = google_api_gateway_api.api_cfg.api_id
  api_config_id = "my-config-${local.name_suffix}"

  grpc_services {
    file_descriptor_set {
      path = "api_descriptor.pb"
      contents = filebase64("test-fixtures/apigateway/api_descriptor.pb")
    }
    source {
      path = "bookstore.proto"
      contents = filebase64("test-fixtures/apigateway/bookstore.proto")
    }
  }
  managed_service_configs {
    path = "api_config.yaml"
    contents = base64encode(<<-EOF
      type: google.api.Service
      config_version: 3
      name: ${google_api_gateway_api.api_cfg.managed_service}
      title: gRPC API example
      apis:
        - name: endpoints.examples.bookstore.Bookstore
      usage:
        rules:
        - selector: endpoints.examples.bookstore.Bookstore.ListShelves
          allow_unregistered_calls: true
      backend:
        rules:
          - selector: "*"
            address: grpcs://example.com
            disable_auth: true

    EOF
    )
  }
  lifecycle {
    create_before_destroy = true
  }
}
