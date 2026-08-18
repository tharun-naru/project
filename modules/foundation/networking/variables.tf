#####################################
# General
#####################################

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}
#####################################
# AWS
#####################################

variable "region" {
  type = string
}

#####################################
# VPC
#####################################

variable "vpc_cidr" {
  type = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Please provide a valid CIDR block for the VPC."
}
}

#####################################
# Subnets
#####################################
variable "public_subnet_cidrs" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.public_subnet_cidrs :
      can(cidrhost(cidr, 0))
    ])
    error_message = "All public subnet CIDRs must be valid CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  type = list(string)

  validation {
    condition = alltrue([
      for cidr in var.private_subnet_cidrs :
      can(cidrhost(cidr, 0))
    ])
    error_message = "All private subnet CIDRs must be valid CIDR blocks."
  }
}
variable "karpenter_discovery_tag" {
  description = "Optional Karpenter discovery tag value"
  type        = string
  default     = null
}
#####################################
# NAT
#####################################

variable "nat_gateway_count" {
  type = number

  validation {
    condition     = var.nat_gateway_count > 0
    error_message = "nat_gateway_count must be greater than 0."
  }

  validation {
    condition     = var.nat_gateway_count <= length(var.public_subnet_cidrs)
    error_message = "nat_gateway_count cannot be greater than the number of public subnets."
  }
}
#####################################
# Azs
#####################################
variable "availability_zone_indexes" {
  description = "Indexes of Availability Zones to use"
  type        = list(number)
}
