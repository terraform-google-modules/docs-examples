resource "google_apphub_application" "example2" {
  location = "us-east1"
  application_id = "example-application-${local.name_suffix}"
  display_name = "Application Full-${local.name_suffix}"
  scope {
    type = "REGIONAL"
  }
  description = "Application for testing-${local.name_suffix}"
  attributes {
    environment {
      type = "STAGING"
		}
		criticality {  
      type = "MISSION_CRITICAL"
		}
		business_owners {
		  display_name =  "Alice-${local.name_suffix}"
		  email        =  "alice@google.com-${local.name_suffix}"
		}
		developer_owners {
		  display_name =  "Bob-${local.name_suffix}"
		  email        =  "bob@google.com-${local.name_suffix}"
		}
		operator_owners {
		  display_name =  "Charlie-${local.name_suffix}"
		  email        =  "charlie@google.com-${local.name_suffix}"
		}
  }
}
