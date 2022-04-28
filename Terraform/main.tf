module "aws_instance" {
  source             = "./modules/TF.Module.AWS.EC2"
  global             = var.global
  awsKeyPair         = var.awsKeyPair
  aws_instance       = var.aws_instance
  aws_security_group = var.aws_security_group
}



