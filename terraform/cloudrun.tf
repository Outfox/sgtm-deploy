resource "google_service_account" "sgtm_service_account" {
  project      = var.project_id
  account_id   = var.service_account
  display_name = "Service account for sGTM"
  depends_on   = [google_project_service.iam]
}

resource "google_project_iam_member" "sa_logging" {
  project    = var.project_id
  role       = "roles/logging.logWriter"
  member     = "serviceAccount:${google_service_account.sgtm_service_account.email}"
  depends_on = [google_service_account.sgtm_service_account]
}


# sGTM Preview server:
resource "google_cloud_run_service" "sgtm_preview" {
  name     = var.service_name_preview
  location = var.region

  depends_on = [
    google_project_service.cloudrun,
    google_service_account.sgtm_service_account
  ]

  template {
    spec {
      containers {
        image = "gcr.io/cloud-tagging-10302018/gtm-cloud-image:stable"
        env {
          name  = "CONTAINER_CONFIG"
          value = var.container_config
        }
        env {
          name  = "RUN_AS_PREVIEW_SERVER"
          value = true
        }
      }
      service_account_name = google_service_account.sgtm_service_account.email
    }
    metadata {
      annotations = {
        "run.googleapis.com/cpu-throttling" = true,
        "autoscaling.knative.dev/minScale"  = "0",
        "autoscaling.knative.dev/maxScale"  = "1"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }


}


# sGTM server:
resource "google_cloud_run_service" "sgtm" {
  name     = var.service_name
  location = var.region

  depends_on = [
    google_cloud_run_service.sgtm_preview
  ]

  template {
    spec {
      containers {
        image = "gcr.io/cloud-tagging-10302018/gtm-cloud-image:stable"
        env {
          name  = "CONTAINER_CONFIG"
          value = var.container_config
        }
        env {
          name  = "PREVIEW_SERVER_URL"
          value = google_cloud_run_service.sgtm_preview.status[0].url
        }
      }
      service_account_name = google_service_account.sgtm_service_account.email
    }
    metadata {
      annotations = {
        "run.googleapis.com/cpu-throttling" = false,
        "autoscaling.knative.dev/minScale"  = var.min_instances,
        "autoscaling.knative.dev/maxScale"  = var.max_instances
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

}

resource "google_cloud_run_service_iam_member" "allUsers_preview" {
  service  = google_cloud_run_service.sgtm_preview.name
  location = google_cloud_run_service.sgtm_preview.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service_iam_member" "allUsers" {
  service  = google_cloud_run_service.sgtm.name
  location = google_cloud_run_service.sgtm.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

