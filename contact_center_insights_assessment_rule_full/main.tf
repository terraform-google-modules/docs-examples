resource "google_contact_center_insights_assessment_rule" "assessment_rule_full" {
  display_name = "assessmentrulefull-${local.name_suffix}"
  assessment_rule_id = "assessmentrulefull-${local.name_suffix}%{id_suffix}"
  location = "us-central1"
  sample_rule {
    sample_percentage = 0.5
    conversation_filter = "medium=\"CHAT\""
  }
  schedule_info {
    schedule = "every 5 minutes"
    time_zone = "America/Los_Angeles"
  }
  active    = true
}
