resource "aws_sqs_queue" "interruption" {

  name = "${var.cluster_name}-karpenter-interruptions"

  message_retention_seconds = 300

  sqs_managed_sse_enabled = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.cluster_name}-karpenter-interruptions"
    }
  )
}
