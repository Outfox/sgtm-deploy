resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "google_storage_bucket" "tf_backend" {
  name                        = "terraform-sgtm-${random_id.bucket_suffix.hex}"
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  force_destroy               = false
  versioning {
    enabled = true
  }
}
