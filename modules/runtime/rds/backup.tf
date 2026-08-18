############################################
# Automated Backups
############################################

resource "aws_db_instance_automated_backups_replication" "this" {

  count = var.enable_backup_replication ? 1 : 0

  source_db_instance_arn = aws_db_instance.this.arn

  kms_key_id = var.backup_kms_key_arn

}
