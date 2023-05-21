variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "service_account" {
  type        = string
  description = "Name of service account to run sGTM"
}

variable "container_config" {
  type        = string
  description = "sGTM container config ID"
}

variable "min_instances" {
  type        = string
  description = "Min Cloud Run instances"
}

variable "max_instances" {
  type        = string
  description = "Max Cloud Run instances"
}
