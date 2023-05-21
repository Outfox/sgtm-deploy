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
  description = "Name of sGTM service"
  default     = "sgtm"
}

variable "service_name_preview" {
  type        = string
  description = "Name of sGTM preview service"
  default     = "sgtm-preview"
}