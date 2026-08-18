resource "aws_kms_key" "terraform_state" {

  description             = "KMS key for Terraform state"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "${var.project_name}-kms"
    Project     = var.project_name
   }
}

resource "aws_kms_alias" "terraform_state" {

  name = "alias/${var.project_name}-terraform-state"

  target_key_id = aws_kms_key.terraform_state.key_id
}
