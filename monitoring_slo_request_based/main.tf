resource "google_monitoring_custom_service" "customsrv" {
  service_id = "custom-srv-request-slos-${local.name_suffix}"
  display_name = "My Custom Service"
}

resource "google_monitoring_slo" "request_based_slo" {
  service = google_monitoring_custom_service.customsrv.service_id
  slo_id = "consumed-api-slo-${local.name_suffix}"
  display_name = "Terraform Test SLO with request based SLI (good total ratio)"

  goal = 0.9
  rolling_period_days = 30

  request_based_sli {
    distribution_cut {
          distribution_filter = "metric.type=\"serviceruntime.googleapis.com/api/request_latencies\" resource.type=\"api\"  "
          range {
            max = 0.5
          }
        }
  }
}
