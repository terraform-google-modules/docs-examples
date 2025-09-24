resource "google_discovery_engine_data_connector" "jira-basic" {
  location                  = "global"
  collection_id             = "collection-id-${local.name_suffix}"
  collection_display_name   = "tf-test-dataconnector-jira"
  data_source             = "jira"
  params = {
      instance_id         = "33db20a3-dc45-4305-a505-d70b68599840"
      instance_uri        = "https://vaissptbots1.atlassian.net/"
      client_secret       = "client-secret-${local.name_suffix}"
      client_id           = "client-id-${local.name_suffix}"
      refresh_token       = "fill-in-the-blank"
  }
  refresh_interval        = "86400s"
  entities {
      entity_name         = "project"
  }
  entities {
      entity_name         = "issue"
  }
  entities {
      entity_name         = "attachment"
  }
  entities {
      entity_name         = "comment"
  }
  entities {
      entity_name         = "worklog"
  }
  static_ip_enabled       = true
}
