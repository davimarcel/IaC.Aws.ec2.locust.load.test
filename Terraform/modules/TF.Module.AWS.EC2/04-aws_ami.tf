data "aws_ami" "ami" {
  most_recent = true
  owners      = ["137112412989"] # Aws

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}


resource "aws_instance" "this" {
  for_each = { for k, v in var.aws_instance : k => v
    if v.enabled == true
  }
  ami           = data.aws_ami.ami.id
  instance_type = each.value.instance_type
  key_name      = aws_key_pair.this[each.value.key_name_indexJson].key_name
  #iam_instance_profile = each.value.instance_type

  network_interface {
    network_interface_id = aws_network_interface.this[each.key].id
    device_index         = 0
  }

  tags = each.value.tags
}

output "aws_instance" {
  value = { for k, v in aws_instance.this : k => {
    id         = v.id
    private_ip = v.private_ip
    public_ip  = v.public_ip
  } }
}

