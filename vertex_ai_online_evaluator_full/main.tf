resource "google_vertex_ai_reasoning_engine" "engine" {
  display_name = "reasoning-engine-${local.name_suffix}"
  description  = "Reasoning engine evaluated by the online evaluator"
  region       = "us-central1"
}

resource "google_vertex_ai_evaluation_metric" "metric" {
  evaluation_metric_id = "eval-metric-${local.name_suffix}"
  region               = "us-central1"
  display_name         = "Custom response quality"

  metric = jsonencode({
    llmBasedMetricSpec = {
      metricPromptTemplate = "Rate the quality of the following response on a scale of 1 to 5. Response: {response}"
    }
    metadata = {
      title = "custom-response-quality"
      scoreRange = {
        min = 1
        max = 5
      }
    }
  })
}

resource "google_vertex_ai_online_evaluator" "evaluator" {
  region         = "us-central1"
  display_name   = "online-evaluator-${local.name_suffix}"
  agent_resource = google_vertex_ai_reasoning_engine.engine.id

  config {
    random_sampling {
      percentage = 100
    }
  }

  cloud_observability {
    open_telemetry {
      semconv_version = "1.39.0"
    }

    session_scope {
      inactivity_trigger {
        threshold = "3600s"
      }

      filter {
        total_token_usage {
          comparison_operator = "GREATER"
          value               = 0
        }
      }
      filter {
        user_turns {
          comparison_operator = "GREATER"
          value               = 0
        }
      }
      filter {
        model_calls {
          comparison_operator = "GREATER"
          value               = 0
        }
      }
      filter {
        model_call_errors {
          comparison_operator = "GREATER_OR_EQUAL"
          value               = 0
        }
      }
      filter {
        tool_calls {
          comparison_operator = "GREATER"
          value               = 0
        }
      }
      filter {
        tool_call_errors {
          comparison_operator = "GREATER_OR_EQUAL"
          value               = 0
        }
      }
      filter {
        duration {
          comparison_operator = "GREATER"
          value               = 0
        }
      }
    }
  }

  # Registered metric, referencing a separate google_vertex_ai_evaluation_metric.
  metric_sources {
    metric_resource_name = google_vertex_ai_evaluation_metric.metric.id
  }
}
