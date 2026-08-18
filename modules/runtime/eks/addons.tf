############################################
# EKS Managed Add-ons
############################################

resource "aws_eks_addon" "this" {

  for_each = {
    for name, addon in var.addons :
    name => addon
    if addon.type == "eks"
  }

  cluster_name = aws_eks_cluster.this.name

  addon_name = each.key

  addon_version = try(
    each.value.addon_version,
    null
  )

  resolve_conflicts_on_create = each.value.resolve_conflicts_on_create

  resolve_conflicts_on_update = each.value.resolve_conflicts_on_update

  service_account_role_arn = try(
    aws_iam_role.irsa[each.value.irsa_role].arn,
    null
  )

  tags = local.common_tags

  depends_on = [
    aws_eks_node_group.this
  ]

}

############################################
# Helm Add-ons - AWS Load Balancer Controller
############################################

resource "helm_release" "aws_load_balancer_controller" {

  for_each = {
    for name, addon in var.addons :
    name => addon
    if addon.type == "helm"
    && name == "aws-load-balancer-controller"
  }

  name = each.key

  repository = each.value.repository
  chart      = each.value.chart
  namespace  = each.value.namespace

  version = try(
    each.value.version,
    null
  )

  create_namespace = each.value.create_namespace

  wait    = true
  timeout = 600

  values = [
    yamlencode(
      merge(
        try(each.value.values, {}),

        try(each.value.irsa_role, null) == null ? {} : {
          serviceAccount = {
            create = true

            annotations = {
              "eks.amazonaws.com/role-arn" = aws_iam_role.irsa[
                each.value.irsa_role
              ].arn
            }
          }
        }
      )
    )
  ]

  dynamic "set" {

    for_each = try(
      each.value.set,
      {}
    )

    content {

      name  = set.key
      value = set.value

    }
  }

  depends_on = [
    aws_eks_addon.this,
    aws_eks_access_entry.this,
    aws_eks_access_policy_association.this
  ]
}


############################################
# Helm Add-ons - Other
############################################

resource "helm_release" "this" {

  for_each = {
    for name, addon in var.addons :
    name => addon
    if addon.type == "helm"
    && name != "aws-load-balancer-controller"
  }

  name = each.key

  repository = each.value.repository
  chart      = each.value.chart
  namespace  = each.value.namespace

  version = try(
    each.value.version,
    null
  )

  create_namespace = each.value.create_namespace

  wait    = true
  timeout = 600

  values = [
    yamlencode(
      merge(
        try(each.value.values, {}),

        try(each.value.irsa_role, null) == null ? {} : {
          serviceAccount = {
            create = true

            annotations = {
              "eks.amazonaws.com/role-arn" = aws_iam_role.irsa[
                each.value.irsa_role
              ].arn
            }
          }
        }
      )
    )
  ]

  dynamic "set" {

    for_each = try(
      each.value.set,
      {}
    )

    content {

      name  = set.key
      value = set.value

    }
  }

  depends_on = [
    aws_eks_addon.this,
    helm_release.aws_load_balancer_controller,
    aws_eks_access_entry.this,
    aws_eks_access_policy_association.this
  ]
}
