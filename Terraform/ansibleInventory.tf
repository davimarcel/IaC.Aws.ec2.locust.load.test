###  Export Inventory Ansible File

resource "local_file" "AnsibleInventory" {
    content = templatefile("inventory.tpl",
        {
            # master = data.aws_instances.master.private_ips
            # nodes =  data.aws_instances.node.private_ips
            master = data.aws_instances.master.public_ips
            nodes = data.aws_instances.node.public_ips
        }
    )
    filename = "../Ansible/inventory"
    depends_on = [module.aws_instance]
}

data "aws_instances" "master" {
    instance_tags = {
        Deploy = "locust"
        Type = "master"
    }
    depends_on = [module.aws_instance]
}

output "locust-master" {
   # value = data.aws_instances.master.private_ips
    value = data.aws_instances.master.public_ips
}


data "aws_instances" "node" {
    instance_tags = {
        Deploy = "locust"
        Type = "node"
    }
    depends_on = [module.aws_instance]
}

output "locust-nodes" {
   # value = data.aws_instances.node.private_ips
   value = data.aws_instances.node.public_ips
}