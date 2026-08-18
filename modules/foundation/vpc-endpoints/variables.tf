variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the endpoints"
  type        = string
}

variable "private_route_table_ids" {
  description = "Private route tables for gateway endpoints"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnets for interface endpoints"
  type        = list(string)
}

variable "endpoint_security_group_id" {
  description = "Security group ID allowed to access interface endpoints"
  type        = string
  default     = null
}

variable "create_endpoint_security_group" {
  description = "Whether the module creates the interface endpoint security group"
  type        = bool
  default     = true
}

variable "interface_endpoint_ingress_cidr_blocks" {
  description = "CIDRs allowed to access interface endpoints"
  type        = list(string)
  default     = []
}

variable "gateway_endpoints" {
  description = "Gateway VPC endpoints to create"
  type        = set(string)
  default     = []
}

variable "interface_endpoints" {
  description = "Interface VPC endpoints to create"
  type        = set(string)
  default     = []
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
