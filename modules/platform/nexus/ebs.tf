resource "aws_ebs_volume" "nexus_data" {
  availability_zone = data.aws_subnet.nexus.availability_zone
  size              = var.data_volume_size
  type              = var.data_volume_type
  encrypted         = true

  tags = merge(
    local.nexus_tags,
    {
      Name = "${local.nexus_name}-data"
      Type = "Nexus-Data"
    }
  )
}

resource "aws_volume_attachment" "nexus_data" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.nexus_data.id
  instance_id = aws_instance.nexus.id

  stop_instance_before_detaching = true
}
