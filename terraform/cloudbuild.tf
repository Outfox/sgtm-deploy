
# Service account for Cloud Build:

resource "google_service_account" "cloud_builder" {
  project      = var.project_id
  display_name = "Service account for Cloud Build"
  account_id   = var.build_service_account
  depends_on   = [google_project_service.iam]
}

resource "google_project_iam_custom_role" "cloud_builder" {
  project     = var.project_id
  role_id     = "cloudBuilder"
  title       = "Cloud Build Runner"
  description = "Permissions to trigger Cloud Builds"
  permissions = ["cloudbuild.builds.create", "cloudscheduler.jobs.run", "logging.logEntries.create", "logging.logEntries.route"]
  depends_on  = [google_project_service.iam]
}

resource "google_project_iam_member" "cloud_builder" {
  project    = var.project_id
  role       = google_project_iam_custom_role.cloud_builder.name
  member     = "serviceAccount:${google_service_account.cloud_builder.email}"
  depends_on = [google_project_iam_custom_role.cloud_builder]
}

resource "google_project_iam_member" "run_admin" {
  project    = var.project_id
  role       = "roles/run.admin"
  member     = "serviceAccount:${google_service_account.cloud_builder.email}"
  depends_on = [google_service_account.cloud_builder]
}

resource "google_project_iam_member" "service_account" {
  project    = var.project_id
  role       = "roles/iam.serviceAccountUser"
  member     = "serviceAccount:${google_service_account.cloud_builder.email}"
  depends_on = [google_service_account.cloud_builder]
}


# Create Cloud Build Trigger:

resource "google_cloudbuild_trigger" "sgtm" {
  name            = "sgtm-update"
  location        = var.region
  service_account = google_service_account.cloud_builder.id
  description     = "Creates new revision in Cloud Run for sGTM"

  webhook_config {
    secret = ""
  }

  build {

    # Create revision for sGTM server:
    step {
      name       = "gcr.io/cloud-builders/gsutil"
      entrypoint = "gcloud"
      args = [
        "run",
        "deploy",
        "${var.service_name}",
        "--service-account",
        "${google_service_account.sgtm_service_account.email}",
        "--region",
        "${var.region}",
        "--image",
        "${var.image_path}",
        "--min-instances",
        "${var.min_instances}",
        "--max-instances",
        "${var.max_instances}",
        "--allow-unauthenticated",
        "--no-cpu-throttling",
        "--update-env-vars",
        "PREVIEW_SERVER_URL=${google_cloud_run_service.sgtm_preview.status[0].url},CONTAINER_CONFIG=${var.container_config}"
      ]
    }

    # Create revision for sGTM preview server:
    step {
      name       = "gcr.io/cloud-builders/gsutil"
      entrypoint = "gcloud"
      args = [
        "run",
        "deploy",
        "${var.service_name_preview}",
        "--service-account",
        "${google_service_account.sgtm_service_account.email}",
        "--region",
        "${var.region}",
        "--image",
        "${var.image_path}",
        "--min-instances",
        "0",
        "--max-instances",
        "1",
        "--allow-unauthenticated",
        "--no-cpu-throttling",
        "--update-env-vars",
        "RUN_AS_PREVIEW_SERVER=true,CONTAINER_CONFIG=${var.container_config}"
      ]
    }

    options {
      logging = "CLOUD_LOGGING_ONLY"
    }

  }

  approval_config {
    approval_required = false
  }

  depends_on = [google_cloud_run_service.sgtm_preview, google_project_iam_member.service_account]

}
