locals {
  preview_server_url = google_cloud_run_service.sgtm_preview.status[0].url
}

output "previewServerUrl" {
  value = local.preview_server_url
}