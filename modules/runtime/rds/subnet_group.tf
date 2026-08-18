resource "aws_db_subnet_group" "this" {

  name = "${local.db_identifier}-subnet-group"

  description = "RDS subnet group"

  subnet_ids = var.private_subnet_ids

  tags = merge(

    local.common_tags,

    {

      Name = "${local.db_identifier}-subnet-group"

    }

  )

}
