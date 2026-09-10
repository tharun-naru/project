# ============================================================
# EXISTING PLATFORM EC2 INSTANCES
# ============================================================

data "aws_instance" "jenkins" {
  instance_id = "i-0c350e10caeba825f"
}

data "aws_instance" "nexus" {
  instance_id = "i-0e80a139ba7f688ea"
}

data "aws_instance" "sonarqube" {
  instance_id = "i-08a5e6865a0efbac2"
}
