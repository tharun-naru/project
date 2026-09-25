# ============================================================
# EXISTING PLATFORM EC2 INSTANCES
# ============================================================

data "aws_instance" "jenkins" {
  instance_id = "i-03966ea3e60255114"
}

data "aws_instance" "nexus" {
  instance_id = "i-0f4fdc2923582849e"
}

data "aws_instance" "sonarqube" {
  instance_id = "i-0c8f2b000d444b6ea"
}
