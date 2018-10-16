resource "google_cloud_tasks_queue" "default" {
  name = "cloud-tasks-queue-test-${local.name_suffix}"
  location = "us-central1"
}
