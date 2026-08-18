############################################
# RDS Instance
############################################

output "db_instance_id" {

  description = "RDS Instance ID"

  value = aws_db_instance.this.id

}

output "db_instance_identifier" {

  description = "RDS Instance Identifier"

  value = aws_db_instance.this.identifier

}

output "db_instance_arn" {

  description = "RDS Instance ARN"

  value = aws_db_instance.this.arn

}

output "db_instance_endpoint" {

  description = "RDS Endpoint"

  value = aws_db_instance.this.endpoint

}

output "db_instance_address" {

  description = "RDS Address"

  value = aws_db_instance.this.address

}

output "db_instance_port" {

  description = "RDS Port"

  value = aws_db_instance.this.port

}

output "db_instance_name" {

  description = "Database Name"

  value = aws_db_instance.this.db_name

}

############################################
# Networking
############################################

output "db_subnet_group_name" {

  description = "DB Subnet Group"

  value = aws_db_subnet_group.this.name

}

output "db_security_group_id" {

  description = "RDS Security Group"

  value = aws_security_group.this.id

}

############################################
# Parameter Group
############################################

output "db_parameter_group_name" {

  description = "Parameter Group"

  value = aws_db_parameter_group.this.name

}

############################################
# Monitoring
############################################

output "monitoring_role_arn" {

  description = "Enhanced Monitoring IAM Role"

  value = aws_iam_role.monitoring.arn

}
############################################
# Credentials
############################################

output "master_user_secret_arn" {

  description = "AWS Secrets Manager ARN containing the RDS master username and password"

  value = try(
    aws_db_instance.this.master_user_secret[0].secret_arn,
    null
  )

}
