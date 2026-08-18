resource "aws_dynamodb_table" "terraform_lock" {

  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {

    name = "LockID"
    type = "S"

  }

  point_in_time_recovery {

    enabled = true

  }

  server_side_encryption {

    enabled     = true
    kms_key_arn = aws_kms_key.terraform_state.arn

  }

  tags = {
    Name        = "${var.project_name}-lock-table"
    Project     = var.project_name
   }
}
