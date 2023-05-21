
resource "google_logging_project_sink" "default" {
  name        = "_Default"
  destination = "logging.googleapis.com/projects/${var.project_id}/locations/global/buckets/_Default"

  disabled               = false
  unique_writer_identity = true
  filter                 = "NOT LOG_ID(\"cloudaudit.googleapis.com/activity\") AND NOT LOG_ID(\"externalaudit.googleapis.com/activity\") AND NOT LOG_ID(\"cloudaudit.googleapis.com/system_event\") AND NOT LOG_ID(\"externalaudit.googleapis.com/system_event\") AND NOT LOG_ID(\"cloudaudit.googleapis.com/access_transparency\") AND NOT LOG_ID(\"externalaudit.googleapis.com/access_transparency\")"

  exclusions {
    name        = "sgtm_exclude"
    description = "Exclude requests to sGTM"
    filter      = "resource.labels.service_name='${var.service_name}' AND httpRequest.status <= 300"
  }

}
