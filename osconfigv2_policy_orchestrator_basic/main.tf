resource "google_os_config_v2_policy_orchestrator" "policy_orchestrator" {
    policy_orchestrator_id = "po-${local.name_suffix}"
    
    state = "ACTIVE"
    action = "UPSERT"
    
    orchestrated_resource {
        id = "test-orchestrated-resource-${local.name_suffix}"
        os_policy_assignment_v1_payload {
            os_policies {
                id = "test-os-policy-${local.name_suffix}"
                mode = "VALIDATION"
                resource_groups {
                    resources {
                        id = "resource-tf"
                        file {
                            content = "file-content-tf"
                            path = "file-path-tf-1"
                            state = "PRESENT"
                        }
                    }
                }
            }
            instance_filter {
                inventories {
                    os_short_name = "windows-10"
                }
            }
            rollout {
                disruption_budget {
                    percent = 100
                }
                min_wait_duration = "60s"
            }
        }
    }
    labels = {
        state = "active"
    }
}
