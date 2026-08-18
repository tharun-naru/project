resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {

  bucket = aws_s3_bucket.terraform_state.id

  rule {

    id     = "terraform-state-lifecycle"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {

      noncurrent_days = 90

    }

  }

}
