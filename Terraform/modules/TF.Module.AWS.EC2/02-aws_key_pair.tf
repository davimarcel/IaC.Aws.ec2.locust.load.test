resource "aws_key_pair" "this" {
  for_each = { for k, v in var.awsKeyPair : k => v
    if v.enabled == true
  }
  key_name   = each.value.key_name
  public_key = each.value.public_key
  tags = merge(
    var.global.tags,
    lookup(each.value, "tags", null)
  )
}

