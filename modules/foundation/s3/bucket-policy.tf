############################################
# Bucket Policy
############################################

data "aws_iam_policy_document" "this" {

  for_each = var.buckets

  ############################################
  # Deny HTTP
  ############################################

  statement {

    sid = "DenyInsecureTransport"

    effect = "Deny"

    principals {

      type = "*"

      identifiers = ["*"]

    }

    actions = [

      "s3:*"

    ]

    resources = [

      aws_s3_bucket.this[each.key].arn,

      "${aws_s3_bucket.this[each.key].arn}/*"

    ]

    condition {

      test = "Bool"

      variable = "aws:SecureTransport"

      values = [

        "false"

      ]

    }

  }

  ############################################
  # Require KMS Encryption
  ############################################

  statement {

    sid = "RequireKMSEncryption"

    effect = "Deny"

    principals {

      type = "*"

      identifiers = ["*"]

    }

    actions = [

      "s3:PutObject"

    ]

    resources = [

      "${aws_s3_bucket.this[each.key].arn}/*"

    ]

    condition {

      test = "StringNotEquals"

      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"

      values = [

        each.value.kms_key_arn

      ]

    }

  }

}

resource "aws_s3_bucket_policy" "this" {

  for_each = var.buckets

  bucket = aws_s3_bucket.this[each.key].id

  policy = data.aws_iam_policy_document.this[each.key].json
  
}

