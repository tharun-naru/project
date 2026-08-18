output "bucket_ids" {

  description = "IDs of S3 Buckets"

  value = {

    for key, bucket in aws_s3_bucket.this :

    key => bucket.id

  }

}

output "bucket_arns" {

  description = "ARNs of S3 Buckets"

  value = {

    for key, bucket in aws_s3_bucket.this :

    key => bucket.arn

  }

}

output "bucket_names" {

  description = "Names of S3 Buckets"

  value = {

    for key, bucket in aws_s3_bucket.this :

    key => bucket.bucket

  }

}

output "bucket_domain_names" {

  description = "Bucket Regional Domain Names"

  value = {

    for key, bucket in aws_s3_bucket.this :

    key => bucket.bucket_regional_domain_name

  }

}

output "bucket_region" {

  description = "AWS Region"

  value = data.aws_region.current.name

}

