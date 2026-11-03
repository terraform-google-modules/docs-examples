resource "google_ces_app" "app" {
  location     = "us"
  app_id       = "ces-app-${local.name_suffix}"
  display_name = "ces-app-${local.name_suffix}"

  time_zone_settings {
    time_zone = "America/Los_Angeles"
  }
}

resource "google_ces_tool" "tool_1" {
  location       = "us"
  app            = google_ces_app.app.name
  tool_id        = "ces-tool-1-${local.name_suffix}"
  execution_type = "SYNCHRONOUS"

  python_function {
    name        = "lookup_order"
    python_code = "def lookup_order(order_id: str) -> str: return order_id"
  }
}

resource "google_ces_tool" "tool_2" {
  location       = "us"
  app            = google_ces_app.app.name
  tool_id        = "ces-tool-2-${local.name_suffix}"
  execution_type = "SYNCHRONOUS"

  python_function {
    name        = "lookup_customer"
    python_code = "def lookup_customer(customer_id: str) -> str: return customer_id"
  }
}

resource "google_ces_toolset" "toolset_1" {
  location       = "us"
  app            = google_ces_app.app.name
  toolset_id     = "ces-toolset-1-${local.name_suffix}"
  display_name   = "ces-toolset-1-${local.name_suffix}"
  execution_type = "SYNCHRONOUS"

  open_api_toolset {
    open_api_schema = <<-EOT
      openapi: 3.0.0
      info:
        title: Order API
        version: 1.0.0
      servers:
        - url: https://api.example.com/v1
      paths:
        /orders:
          get:
            operationId: getOrder
            parameters:
              - name: order_id
                in: query
                required: true
                schema:
                  type: string
            responses:
              '200':
                description: OK
    EOT
  }
}

resource "google_ces_toolset" "toolset_2" {
  location       = "us"
  app            = google_ces_app.app.name
  toolset_id     = "ces-toolset-2-${local.name_suffix}"
  display_name   = "ces-toolset-2-${local.name_suffix}"
  execution_type = "SYNCHRONOUS"

  open_api_toolset {
    open_api_schema = <<-EOT
      openapi: 3.0.0
      info:
        title: Customer API
        version: 1.0.0
      servers:
        - url: https://api.example.com/v1
      paths:
        /customers:
          post:
            operationId: updateCustomer
            parameters:
              - name: customer_id
                in: query
                required: true
                schema:
                  type: string
            responses:
              '200':
                description: OK
    EOT
  }
}

resource "google_dialogflow_companion_agent" "default" {
  location           = "us"
  companion_agent_id = "companion-tools-${local.name_suffix}"
  display_name       = "companion-tools-updated-${local.name_suffix}"
  description        = "Updated Companion Agent with CES tools"

  ces_tool_specs {
    ces_tool                 = google_ces_tool.tool_2.id
    confirmation_requirement = "REQUIRED"
    proactive_enabled        = false
    reactive_enabled         = true
    parameter_overrides {
      parameter_name        = "customer_id"
      context_reference_key = "customer_context"
      field_path            = "customer.id"
    }
  }

  toolset_tools {
    toolset                  = google_ces_toolset.toolset_2.id
    operation_id             = "updateCustomer"
    confirmation_requirement = "REQUIRED"
    proactive_enabled        = true
    reactive_enabled         = false
    parameter_overrides {
      parameter_name        = "customer_id"
      context_reference_key = "customer_context"
      field_path            = "customer.id"
    }
  }
}
