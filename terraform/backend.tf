terraform {
  backend "gcs" {
    bucket = "terraform-sgtm-058c125dd9b4f8bd"
    prefix = "terraform/state"
  }
}
