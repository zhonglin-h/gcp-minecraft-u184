resource "google_project_iam_custom_role" "instance-state-editor" {
  role_id     = "instanceStateEditor"
  title       = "Start and Stop Compute Instances"
  description = "A description"
  permissions = ["compute.instances.start", "compute.instances.stop"]
}