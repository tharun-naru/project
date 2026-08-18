resource "aws_db_instance" "this" {

  identifier = local.db_identifier

  ####################################################
  # Engine
  ####################################################

  engine = var.engine

  engine_version = var.engine_version

  db_name = var.database_name

  ####################################################
  # Compute
  ####################################################

  instance_class = var.instance_class

  ####################################################
  # Storage
  ####################################################

  allocated_storage = var.allocated_storage

  storage_type = var.storage_type

  storage_encrypted = var.storage_encrypted

  kms_key_id = var.storage_encrypted ? var.kms_key_arn : null

  ####################################################
  # Authentication
  ####################################################

  username = var.master_username

  manage_master_user_password = var.manage_master_user_password

  master_user_secret_kms_key_id = var.manage_master_user_password ? var.master_user_secret_kms_arn : null

  ####################################################
  # Networking
  ####################################################

  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [

    aws_security_group.this.id

  ]

  publicly_accessible = var.publicly_accessible

  multi_az = var.multi_az

  ####################################################
  # Parameter Group
  ####################################################

  parameter_group_name = aws_db_parameter_group.this.name

  ####################################################
  # Monitoring
  ####################################################

  monitoring_interval = var.monitoring_interval

  monitoring_role_arn = aws_iam_role.monitoring.arn

  performance_insights_enabled = var.performance_insights_enabled

  ####################################################
  # Backup
  ####################################################

  backup_retention_period = var.backup_retention_period

  backup_window = var.backup_window

  ####################################################
  # Maintenance
  ####################################################

  maintenance_window = var.maintenance_window

  apply_immediately = var.apply_immediately

  ####################################################
  # Logs
  ####################################################

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  ####################################################
  # Protection
  ####################################################

  deletion_protection = var.deletion_protection

  skip_final_snapshot = var.skip_final_snapshot

  ####################################################
  # Tags
  ####################################################

  tags = merge(

    local.common_tags,

    {

      Name = local.db_identifier

    }

  )

  depends_on = [

    aws_db_subnet_group.this,

    aws_security_group.this,

    aws_db_parameter_group.this,

    aws_iam_role.monitoring

  ]

}
