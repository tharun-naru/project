output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_ids" {
  value = aws_route_table.private[*].id
}
output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}
output "allocation_ids" {
  description = "Elastic IP Allocation IDs"
  value       = aws_eip.nat[*].id
}
