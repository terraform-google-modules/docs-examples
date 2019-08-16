resource "google_monitoring_uptime_check_config" "http" {
  display_name = "http-uptime-check-${local.name_suffix}"
  timeout = "60s"

  http_check {
    path = "/some-path"
    port = "8010"
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = "example"
      host = "192.168.1.1"
    }
  }

  content_matchers {
    content = "example"
  }
}
