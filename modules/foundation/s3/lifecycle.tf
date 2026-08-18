############################################
# S3 Lifecycle Configuration
############################################

resource "aws_s3_bucket_lifecycle_configuration" "this" {

  for_each = {

    for key, bucket in var.buckets :

    key => bucket

    if bucket.lifecycle.enabled

  }

  bucket = aws_s3_bucket.this[each.key].id

  rule {

    id = "default-lifecycle"

    status = "Enabled"

    filter {}

    ##########################################
    # Abort Incomplete Multipart Uploads
    ##########################################

    dynamic "abort_incomplete_multipart_upload" {

      for_each = each.value.lifecycle.abort_incomplete_upload_days != null ? [1] : []

      content {

        days_after_initiation = each.value.lifecycle.abort_incomplete_upload_days

      }

    }

    ##########################################
    # Non Current Version Expiration
    ##########################################

    dynamic "noncurrent_version_expiration" {

      for_each = each.value.lifecycle.noncurrent_version_days != null ? [1] : []

      content {

        noncurrent_days = each.value.lifecycle.noncurrent_version_days

      }

    }

    ##########################################
    # Current Object Expiration
    ##########################################

    dynamic "expiration" {

      for_each = each.value.lifecycle.expiration_days != null ? [1] : []

      content {

        days = each.value.lifecycle.expiration_days

      }

    }

    ##########################################
    # Transition Storage Class
    ##########################################

    dynamic "transition" {

      for_each = each.value.lifecycle.transition != null ? [1] : []

      content {

        days = each.value.lifecycle.transition.days

        storage_class = each.value.lifecycle.transition.storage_class

      }

    }

  }

}

