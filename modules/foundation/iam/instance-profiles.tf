############################################

# Dynamic EC2 Instance Profiles

############################################

resource "aws_iam_instance_profile" "this" {

  for_each = {


    for role_key, role in var.iam_roles :

    role_key => role

    if role.create_instance_profile


  }

  name = "${each.value.name}-instance-profile"

  role = aws_iam_role.this[each.key].name

  tags = merge(


    local.common_tags,

    each.value.tags,

    {

      Name = "${each.value.name}-instance-profile"

    }


  )

}

