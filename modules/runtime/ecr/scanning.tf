############################################
# ECR Registry Scanning Configuration
############################################

resource "aws_ecr_registry_scanning_configuration" "scan" {

  scan_type = "BASIC"

  rule {
    scan_frequency = "SCAN_ON_PUSH"

    repository_filter {
      filter      = "*"
      filter_type = "WILDCARD"
    }
  }
}
