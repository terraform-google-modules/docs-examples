resource "google_contact_center_insights_view" "basic_view" {
  location = "us-central1"
  display_name = "view-display-name"
  value    = "medium=\"CHAT\""
}
