resource "aws_security_group" "jenkins" {
  name        = "${var.project_name}-${var.environment}-jenkins-sg"
  description = "Security group for Jenkins private EC2"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-jenkins-sg"
    }
  )
}

# ------------------------------------------------------------
# Jenkins Dashboard
# ALB forwards Jenkins traffic to port 8080
# Only the ALB security group can access Jenkins
# ------------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "jenkins_from_alb" {
  
  security_group_id            = aws_security_group.jenkins.id
  referenced_security_group_id = var.alb_security_group_id
  
  from_port   = var.jenkins_port
  to_port     = var.jenkins_port
  ip_protocol = "tcp"

  description = "Allow Jenkins dashboard traffic from ALB"
}

# ------------------------------------------------------------
# Outbound
# Jenkins uses NAT Gateway for internet access
# ------------------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "jenkins_outbound" {
  security_group_id = aws_security_group.jenkins.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  description = "Allow outbound traffic through NAT Gateway"
}
