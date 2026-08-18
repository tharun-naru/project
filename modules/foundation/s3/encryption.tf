resource "aws_s3_bucket_server_side_encryption_configuration" "this" {

  for_each = var.buckets

  bucket = aws_s3_bucket.this[each.key].id

  rule {

    apply_server_side_encryption_by_default {

      kms_master_key_id = each.value.kms_key_arn

      sse_algorithm = "aws:kms"

    }

    bucket_key_enabled = true

  }

}

