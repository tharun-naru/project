resource "aws_security_group" "nexus" {
  name        = "${var.project_name}-${var.environment}-nexus-sg"
  description = "Security group for Nexus private EC2"
  vpc_id      = var.vpc_id

  tags = merge(
    local.nexus_tags,
    {
      Name = "${local.nexus_name}-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "nexus_from_alb" {

  security_group_id            = aws_security_group.nexus.id
  referenced_security_group_id = var.alb_security_group_id
  
  from_port   = var.nexus_port
  to_port     = var.nexus_port
  ip_protocol = "tcp"

  description = "Allow Nexus traffic from shared ALB"
}

resource "aws_vpc_security_group_egress_rule" "nexus_outbound" {
  security_group_id = aws_security_group.nexus.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  description = "Allow Nexus outbound traffic through NAT"
}
