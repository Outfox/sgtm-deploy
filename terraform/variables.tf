variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region where the service will run"
}

variable "service_account" {
  type        = string
  description = "Name of service account to run sGTM service"
  default     = "server-side-gtm"
}

variable "container_config" {
  type        = string
  description = "sGTM container config ID"
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
