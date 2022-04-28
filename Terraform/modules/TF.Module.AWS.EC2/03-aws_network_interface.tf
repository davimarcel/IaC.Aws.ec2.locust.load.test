resource "aws_network_interface" "this" {
  for_each = { for k, v in var.aws_instance : k => v
    if v.enabled == true
  }
  subnet_id = each.value.subnet_id == null ? var.global.subnet_id : each.value.subnet_id
  #private_ips = ["172.16.10.100"]
  security_groups = [aws_security_group.this[each.value.security_groups].id] #lookup(each.value, "security_group_ids",  null)
  tags = merge(
    var.global.tags,
    lookup(each.value, "tags", null)
  )

}