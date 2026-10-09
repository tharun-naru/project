resource "aws_cloudwatch_log_group" "eks" {

  count = length(var.cluster_log_types) > 0 ? 1 : 0

  name = "/aws/eks/${local.cluster_name}/cluster"

  retention_in_days = var.cluster_log_retention_in_days

  kms_key_id = var.cluster_log_kms_key_arn

  tags = merge(

    local.common_tags,

    {

      Name = "${local.cluster_name}-cluster-logs"

    }

  )

}
