variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region where the service will run"
}

variable "run_service_account" {
  type        = string
  description = "Name of service account to run sGTM service in Cloud Run"
  default     = "server-side-gtm"
}

variable "build_service_account" {
  type        = string
  description = "Name of service account to run Cloud Build"
  default     = "cloud-builder"
}

variable "container_config" {
  type        = string
  description = "sGTM container config ID"
}

variable "image_path" {
  type        = string
  description = "Path to sGTM container image"
  default     = "gcr.io/cloud-tagging-10302018/gtm-cloud-image:stable"
}

variable "min_instances" {
  type        = string
  description = "Minimum Cloud Run instances"
}

variable "max_instances" {
  type        = string
  description = "Maximum Cloud Run instances"
}

variable "service_name" {
  type        = string
  description = "Name of Cloud Run service"
  default     = "sgtm"
}

variable "service_name_preview" {
  type        = string
  description = "Name of Cloud Run preview service"
  default     = "sgtm-preview"
}

variable "enable_uptime_check" {
  type        = bool
  description = "Set to True to enable uptime checks"
  default     = true
}

variable "gtm_container_id" {
  type        = string
  description = "Client side GTM container ID to monitor in uptime checks"
}

variable "alert_emails" {
  type        = list(string)
  description = "Email addresses to notify for uptime checks fails"
}

variable "alert_message" {
  type        = string
  description = "Additional message to include in downtime alert"
  default     = ""
}

variable "custom_domain" {
  type        = string
  description = "Domain name to mapp to sGTM"
  default     = ""
}

variable "cron_schedule" {
  type        = string
  description = "Cron schedule when to run Automatic revision update"
}

variable "cron_timezone" {
  type        = string
  description = "Timezone for cron schedule"
  default     = "UTC"
}