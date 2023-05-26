resource "google_monitoring_notification_channel" "email" {

  for_each = toset(var.alert_emails)

  display_name = each.key
  type         = "email"
  labels = {
    email_address = each.key
  }
}

resource "google_monitoring_uptime_check_config" "sgtm" {
  count        = var.enable_uptime_check ? 1 : 0
  project      = var.project_id
  display_name = "sgtm-uptime-check"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path           = "/gtm.js?id=${var.gtm_container_id}"
    port           = 443
    request_method = "GET"
    use_ssl        = true
    validate_ssl   = true


    accepted_response_status_codes {
      status_class = "STATUS_CLASS_2XX"
    }
    accepted_response_status_codes {
      status_class = "STATUS_CLASS_3XX"
    }
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = replace(google_cloud_run_service.sgtm.status[0].url, "https://", "")
    }
  }

  depends_on = [google_cloud_run_service.sgtm]
}



resource "google_monitoring_alert_policy" "sgtm_alert" {
  count        = var.enable_uptime_check ? 1 : 0
  project      = var.project_id
  display_name = "sGTM not available"
  enabled      = true
  combiner     = "OR"

  conditions {
    display_name = "GTM container not available"

    condition_threshold {
      filter          = "resource.type = \"uptime_url\" AND metric.type = \"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.labels.check_id = \"${google_monitoring_uptime_check_config.sgtm[0].uptime_check_id}\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 3
      aggregations {
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        alignment_period     = "1200s"
        group_by_fields = [
          "resource.label.project_id",
          "resource.label.host"
        ]
      }
      trigger {
        count = 1
      }
    }
  }

  alert_strategy {
    auto_close = "604800s"
  }

  documentation {
    content = "GTM container '${var.gtm_container_id}' could not be retrieved through sGTM in GCP project '${var.project_id}'. ${var.alert_message}"
  }

  notification_channels = values(google_monitoring_notification_channel.email)[*].id

  depends_on = [
    google_monitoring_uptime_check_config.sgtm,
    google_monitoring_notification_channel.email
  ]
}
