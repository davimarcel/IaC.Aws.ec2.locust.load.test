output "instance_ip" {
    value = module.aws_instance
}


output "locust-master" {
   value = "Available in https://master_ip:8080"
}
