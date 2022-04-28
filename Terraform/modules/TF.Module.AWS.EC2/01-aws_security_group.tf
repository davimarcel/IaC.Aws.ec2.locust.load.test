locals {
  ingress = flatten([
    for key, value in var.aws_security_group : [
      for block, block_info in value.ingress : {
        sg             = key
        rule           = block
        description    = block_info.description
        from_port      = block_info.from_port
        to_port        = block_info.to_port
        cidr_blocks    = block_info.cidr_blocks
        protocol       = block_info.protocol
        ipv6_cidr_blocks = block_info.ipv6_cidr_blocks
      }
    ]
  ])
}

locals {
  egress = flatten([
    for key, value in var.aws_security_group : [
      for block, block_info in value.egress : {
        sg             = key
        rule           = block
        description    = block_info.description
        from_port      = block_info.from_port
        to_port        = block_info.to_port
        cidr_blocks    = block_info.cidr_blocks
        protocol       = block_info.protocol
        ipv6_cidr_blocks = block_info.ipv6_cidr_blocks
      }
    ]
  ])
}

######################
### SECURITY GROUP ###
######################

resource "aws_security_group" "this" {
  for_each    = var.aws_security_group
  vpc_id      = each.value.vpc_id == null ? var.global.vpc_id : each.value.vpc_id
  name        = each.value.name
  description = each.value.description
  revoke_rules_on_delete = each.value.revoke_rules_on_delete
  
  dynamic "ingress" {
    for_each = { 
      for block_info in local.ingress : "${block_info.sg}.${block_info.rule}" => block_info 
      if each.key == block_info.sg 
    }

    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      ipv6_cidr_blocks = lookup(ingress.value,"ipv6_cidr_blocks", null)
    }
  }

  dynamic "egress" {
    for_each = { 
      for block_info in local.egress : "${block_info.sg}.${block_info.rule}" => block_info 
      if each.key == block_info.sg 
    }    

    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      ipv6_cidr_blocks = lookup(egress.value,"ipv6_cidr_blocks", null)
    }
  }

  tags = merge(
    var.global.tags,
    lookup(each.value, "tags", null)
  )
}