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
      sse_algorithm = "AES256"
    }
  }
}
