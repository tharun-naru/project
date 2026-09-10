resource "aws_ebs_volume" "data" {
  for_each = var.data_volumes

  availability_zone = data.aws_subnet.sonarqube.availability_zone

  size      = each.value.size
  type      = each.value.type
  encrypted = each.value.encrypted

  tags = merge(
    local.sonarqube_tags,
    {
      Name = "${local.sonarqube_name}-${each.key}-data"
      Type = "${each.key}-Data"
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_volume_attachment" "data" {
  for_each = var.data_volumes

  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.data[each.key].id
  instance_id = aws_instance.sonarqube.id

  stop_instance_before_detaching = true
}
