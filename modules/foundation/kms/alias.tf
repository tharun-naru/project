resource "aws_kms_alias" "this" {

  for_each = var.kms_keys

  name = each.value.alias

  target_key_id = aws_kms_key.this[each.key].key_id

}

