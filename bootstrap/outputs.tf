output "bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
}

output "kms_key_id" {
  value = aws_kms_key.terraform_state.key_id
}

output "kms_key_arn" {
  value = aws_kms_key.terraform_state.arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_lock.name
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.terraform_lock.arn
}
