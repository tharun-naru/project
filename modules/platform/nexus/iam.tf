resource "aws_iam_policy" "nexus" {
  name        = "${var.project_name}-${var.environment}-nexus-policy"
  description = "AWS permissions required by Nexus"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]

        Resource = "*"
      },

      {
        Sid    = "CloudWatchMetrics"
        Effect = "Allow"

        Action = [
          "cloudwatch:PutMetricData"
        ]

        Resource = "*"
      }
    ]
  })

  tags = local.nexus_tags
}
