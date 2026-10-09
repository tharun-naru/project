resource "aws_sqs_queue" "interruption" {

  name = var.interruption_queue_name != null ? (
    var.interruption_queue_name
  ) : "${var.cluster_name}-karpenter-interruptions"

  message_retention_seconds = var.message_retention_seconds

  sqs_managed_sse_enabled = var.sqs_managed_sse_enabled

  kms_master_key_id = var.kms_master_key_id

  tags = merge(
    var.common_tags,
    {
      Name = var.interruption_queue_name != null ? (
        var.interruption_queue_name
      ) : "${var.cluster_name}-karpenter-interruptions"
    }
  )
}
