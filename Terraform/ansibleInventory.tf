###  Export Inventory Ansible File and Services File

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

resource "local_file" "AnsibleServices" {
    content = templatefile("services.tpl",
        {
            master = data.aws_instances.master.private_ips
        }
    )
    filename = "../Ansible/services/locust-node.service"
    depends_on = [module.aws_instance]
}

data "aws_instances" "master" {
    instance_tags = {
        Deploy = "locust"
        Type = "master"
    }
    depends_on = [module.aws_instance]
}
data "aws_instances" "node" {
    instance_tags = {
        Deploy = "locust"
        Type = "node"
    }
    depends_on = [module.aws_instance]
}



