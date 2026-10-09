data "aws_instance" "jenkins" {
 filter {
   name   = "tag:Name"
   values = ["speshway-test-jenkins"]
 }
 filter {
   name   = "instance-state-name"
   values = ["running"]
 }
}
data "aws_instance" "nexus" {
 filter {
   name   = "tag:Name"
   values = ["speshway-test-nexus"]
 }
 filter {
   name   = "instance-state-name"
   values = ["running"]
 }
}
data "aws_instance" "sonarqube" {
 filter {
   name   = "tag:Name"
   values = ["speshway-test-sonarqube"]
 }
 filter {
   name   = "instance-state-name"
   values = ["running"]
 }
}
data "aws_instance" "grafana" {
 filter {
   name   = "tag:Name"
   values = ["speshway-test-monitoring"]
 }
 filter {
   name   = "instance-state-name"
   values = ["running"]
 }
}
