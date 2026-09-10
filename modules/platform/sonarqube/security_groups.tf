resource "aws_security_group" "sonarqube" {
  name        = "${var.project_name}-${var.environment}-sonarqube-sg"
  description = "Security group for private SonarQube EC2"
  vpc_id      = var.vpc_id

  tags = merge(
    local.sonarqube_tags,
    {
      Name = "${local.sonarqube_name}-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "sonarqube_from_alb" {

  security_group_id            = aws_security_group.sonarqube.id
  referenced_security_group_id = var.alb_security_group_id
  
  from_port   = var.sonarqube_port
  to_port     = var.sonarqube_port
  ip_protocol = "tcp"

  description = "Allow SonarQube traffic from shared ALB"
}

resource "aws_vpc_security_group_egress_rule" "sonarqube_outbound" {
  security_group_id = aws_security_group.sonarqube.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  description = "Allow SonarQube outbound traffic through NAT"
}
