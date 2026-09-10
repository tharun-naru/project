resource "aws_iam_policy" "sonarqube" {
  name        = "${var.project_name}-${var.environment}-sonarqube-policy"
  description = "AWS permissions required by SonarQube"

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

  tags = local.sonarqube_tags
}
