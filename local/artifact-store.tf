
resource "aws_kms_key" "artifact_store" {
  description             = "This key is used to encrypt artifact store objects"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_s3_bucket" "artifact_store" {
  force_destroy = true
}

resource "aws_s3_bucket_acl" "artifact_store" {
  bucket = aws_s3_bucket.artifact_store.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifact_store" {
  bucket = aws_s3_bucket.artifact_store.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.artifact_store.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
