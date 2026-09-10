resource "aws_iam_policy" "jenkins" {
  name        = "${var.project_name}-${var.environment}-jenkins-policy"
  description = "AWS permissions required by Jenkins"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "SSM"
        Effect = "Allow"

        Action = [
          "ssm:DescribeInstanceInformation",
          "ssm:GetCommandInvocation",
          "ssm:SendCommand"
        ]

        Resource = "*"
      },

      {
        Sid    = "CloudWatch"
        Effect = "Allow"

        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]

        Resource = "*"
      }
    ]
  })

  tags = var.common_tags
}
