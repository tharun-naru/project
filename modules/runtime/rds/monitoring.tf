resource "aws_iam_role" "monitoring" {

  name = "${local.db_identifier}-monitoring-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "monitoring.rds.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

  tags = merge(

    local.common_tags,

    {

      Name = "${local.db_identifier}-monitoring-role"

    }

  )

}

resource "aws_iam_role_policy_attachment" "monitoring" {

  role = aws_iam_role.monitoring.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"

}
