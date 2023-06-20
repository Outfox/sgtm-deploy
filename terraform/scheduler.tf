resource "google_cloud_scheduler_job" "trigger-build" {

  count = length(var.cron_schedule) > 0 ? 1 : 0

  project     = var.project_id
  region      = var.region
  name        = "sgtm-update"
  description = "Trigger Cloud Build to update sGTM"

  schedule  = var.cron_schedule
  time_zone = var.cron_timezone

  http_target {
    http_method = "POST"
    uri         = "https://cloudbuild.googleapis.com/v1/projects/${var.project_id}/locations/${var.region}/triggers/${google_cloudbuild_trigger.sgtm.trigger_id}:run"

    oauth_token {
      service_account_email = google_service_account.cloud_builder.email
    }
  }

  depends_on = [google_cloudbuild_trigger.sgtm]
}