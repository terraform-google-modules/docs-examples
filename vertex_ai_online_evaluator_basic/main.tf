resource "google_vertex_ai_reasoning_engine" "engine" {
  display_name = "reasoning-engine-${local.name_suffix}"
  description  = "Reasoning engine evaluated by the online evaluator"
  region       = "us-central1"
}

resource "google_vertex_ai_online_evaluator" "evaluator" {
  region         = "us-central1"
  display_name   = "online-evaluator-${local.name_suffix}"
  agent_resource = google_vertex_ai_reasoning_engine.engine.id

  config {
    max_evaluated_samples_per_run = "100"
    random_sampling {
      percentage = 10
    }
  }

  cloud_observability {
    open_telemetry {
      semconv_version = "1.39.0"
    }

    trace_scope {
      filter {
        duration {
          comparison_operator = "GREATER"
          value               = 0
        }
      }
    }
  }

  metric_sources {
    metric = jsonencode({
      predefinedMetricSpec = {
        metricSpecName = "safety_v1"
      }
    })
  }

  metric_sources {
    metric = jsonencode({
      predefinedMetricSpec = {
        metricSpecName = "final_response_quality_v1"
      }
    })
  }
}
