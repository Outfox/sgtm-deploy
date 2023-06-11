resource "google_logging_project_exclusion" "sgtm-exclusion" {
  name        = "sgtm-exclusion"
  project     = var.project_id
  description = "Exclude requests to sGTM"

  filter = "resource.labels.service_name=\"${var.service_name}\" AND httpRequest.status < 400"
}