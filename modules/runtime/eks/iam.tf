resource "aws_iam_policy" "karpenter_controller" {

  name        = "${local.cluster_name}-karpenter-controller"
  description = "Karpenter Controller Policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      ##################################################
      # EC2 Read
      ##################################################

      {
        Sid    = "EC2Read"

        Effect = "Allow"

        Action = [

          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs"

        ]

        Resource = "*"

      },

      ##################################################
      # Launch / Delete EC2
      ##################################################

      {
        Sid    = "EC2Launch"

        Effect = "Allow"

        Action = [

          "ec2:RunInstances",
          "ec2:CreateFleet",
          "ec2:TerminateInstances",
          "ec2:CreateLaunchTemplate",
          "ec2:DeleteLaunchTemplate"

        ]

        Resource = "*"

      },

      ##################################################
      # Instance Profile
      ##################################################

      {
        Sid    = "PassNodeRole"

        Effect = "Allow"

        Action = [

          "iam:PassRole"

        ]

        Resource = var.node_role_arn

      },

      ##################################################
      # Instance Profile Management
      ##################################################

      {
      Sid    = "InstanceProfileManagement"

      Effect = "Allow"

      Action = [
        "iam:CreateInstanceProfile",
        "iam:DeleteInstanceProfile",
        "iam:AddRoleToInstanceProfile",
        "iam:RemoveRoleFromInstanceProfile",
        "iam:GetInstanceProfile",
        "iam:ListInstanceProfiles",
        "iam:TagInstanceProfile"
          ]

      Resource = "*"
      },

      ##################################################
      # SSM
      ##################################################

      {
        Sid    = "SSM"

        Effect = "Allow"

        Action = [

          "ssm:GetParameter"

        ]

        Resource = "*"

      },

      ##################################################
      # Pricing
      ##################################################

      {
        Sid    = "Pricing"

        Effect = "Allow"

        Action = [

          "pricing:GetProducts"

        ]

        Resource = "*"

      },

      ##################################################
      # EKS
      ##################################################

      {
        Sid    = "EKS"

        Effect = "Allow"

        Action = [

          "eks:DescribeCluster"

        ]

        Resource = "*"

      },

      ##################################################
      # SQS (Interruption Queue)
      ##################################################

      {
        Sid    = "SQS"

        Effect = "Allow"

        Action = [

          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"

        ]

        Resource = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.cluster_name}-karpenter-interruption"

      },

      ##################################################
      # Tagging
      ##################################################

      {
        Sid    = "Tagging"

        Effect = "Allow"

        Action = [

          "ec2:CreateTags",
          "ec2:DeleteTags"

        ]

        Resource = "*"

      }

    ]

  })

  tags = var.common_tags

}
resource "aws_iam_role" "karpenter_controller" {

  name = "${local.cluster_name}-karpenter-controller"

  assume_role_policy = data.aws_iam_policy_document.irsa.json

  tags = var.common_tags

}
resource "aws_iam_role_policy_attachment" "controller" {

  role = aws_iam_role.karpenter_controller.name

  policy_arn = aws_iam_policy.karpenter_controller.arn

}
data "aws_iam_policy_document" "irsa" {

  statement {

    actions = [

      "sts:AssumeRoleWithWebIdentity"

    ]

    principals {

      type = "Federated"

      identifiers = [

        aws_iam_openid_connect_provider.this[0].arn

      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(
        aws_iam_openid_connect_provider.this[0].url,
        "https://",
        ""
     )}:sub"

      values = [

        "system:serviceaccount:karpenter:karpenter"

      ]

    }

  }

}
