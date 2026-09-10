resource "aws_ebs_volume" "jenkins_data" {
  availability_zone = data.aws_subnet.jenkins.availability_zone
  size              = var.data_volume_size
  type              = var.data_volume_type
  encrypted         = true

  tags = merge(
    local.jenkins_tags,
    {
      Name = "${local.jenkins_name}-data"
      Type = "Jenkins-Data"
    }
  )
}

resource "aws_volume_attachment" "jenkins_data" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.jenkins_data.id
  instance_id = aws_instance.jenkins.id

  stop_instance_before_detaching = true
}
