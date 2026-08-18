output "gateway_endpoint_ids" {
  description = "Gateway VPC endpoint IDs"
  value       = { for k, v in aws_vpc_endpoint.gateway : k => v.id }
}

output "interface_endpoint_ids" {
  description = "Interface VPC endpoint IDs"
  value       = { for k, v in aws_vpc_endpoint.interface : k => v.id }
}

output "endpoint_security_group_id" {
  description = "Security group ID used by interface endpoints"
  value = var.create_endpoint_security_group ? (
    aws_security_group.endpoint[0].id
  ) : var.endpoint_security_group_id
}
