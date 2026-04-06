resource "google_contact_center_insights_assessment_rule" "assessment_rule_basic" {
  display_name = "assessmentrulebasic-${local.name_suffix}"
  assessment_rule_id = "assessmentrulebasic-${local.name_suffix}%{id_suffix}"
  location = "us-central1"
  sample_rule {
    sample_percentage = 0.5
  }
  schedule_info {
    schedule = "every 5 minutes"
  }
  active    = true
}
