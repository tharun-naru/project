############################################
# S3 Bucket
############################################
resource "aws_s3_bucket" "this" {

  for_each = var.buckets

  bucket = try(

  each.value.bucket_name,

  "${local.name_prefix}-${each.key}"

  )


  force_destroy = each.value.force_destroy

  tags = merge(

    local.common_tags,

    {

      Name = try( each.value.bucket_name, "${local.name_prefix}-${each.key}" )

      Bucket = each.key
      Module = "S3"
    }

  )

}
############################################
# S3 Public Access Block
############################################

resource "aws_s3_bucket_public_access_block" "this" {

  for_each = var.buckets

  bucket = aws_s3_bucket.this[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

############################################
# S3 Ownership Controls
############################################

resource "aws_s3_bucket_ownership_controls" "this" {

  for_each = var.buckets

  bucket = aws_s3_bucket.this[each.key].id

  rule {

    object_ownership = "BucketOwnerEnforced"

  }

}
