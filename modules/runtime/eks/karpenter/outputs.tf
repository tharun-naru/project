############################################
# SQS
############################################

output "interruption_queue_name" {

  description = "Karpenter Interruption Queue Name"

  value = aws_sqs_queue.interruption.name

}

output "interruption_queue_arn" {

  description = "Karpenter Interruption Queue ARN"

  value = aws_sqs_queue.interruption.arn

}

############################################
# Helm
############################################

output "helm_release_name" {

  description = "Karpenter Helm Release Name"

  value = helm_release.karpenter.name

}

############################################
# Node Class
############################################

output "node_classes" {

  value = keys(var.karpenter_node_classes)

}


############################################
# Node Pool
############################################

output "node_pools" {

  value = keys(var.karpenter_node_pools)

}
