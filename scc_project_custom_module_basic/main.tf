resource "google_scc_project_custom_module" "example" {
	display_name = "basic_custom_module-${local.name_suffix}"
	enablement_state = "ENABLED"
	custom_config {
		predicate {
			expression = "resource.rotationPeriod > duration(\"2592000s\")"
		}
		resource_selector {
			resource_types = [
				"cloudkms.googleapis.com/CryptoKey",
			]
		}
		description = "The rotation period of the identified cryptokey resource exceeds 30 days."
		recommendation = "Set the rotation period to at most 30 days."
		severity = "MEDIUM"
	}
}
