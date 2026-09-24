# ============================================================
# EXISTING PLATFORM EC2 INSTANCES
# ============================================================

data "aws_instance" "jenkins" {
  instance_id = "i-0c6ff4f0078284f90"
}

data "aws_instance" "nexus" {
  instance_id = "i-0bfae1da1b442f38a"
}

data "aws_instance" "sonarqube" {
  instance_id = "i-068b62fa292d6e255"
}
