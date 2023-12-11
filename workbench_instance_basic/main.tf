resource "google_workbench_instance" "instance" {
  name = "workbench-instance-${local.name_suffix}"
  location = "us-west1-a"
}
