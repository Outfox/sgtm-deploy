resource "google_project_service" "cloudrun" {
  project = var.project_id
  service = "run.googleapis.com"
}