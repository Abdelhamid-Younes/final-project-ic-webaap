# Creating sg
module "sg" {
  source = "../modules/sg-module"
}

# Creating EIP
module "eip" {
    source = "../modules/eip-module"
}

#Creating ec2 instance
module "ec2" {
  source = "../modules/ec2-module"
  instance_type = var.instance_type
  sg_name = var.sg_name
  public_ip = module.eip.output_eip_ip
  deploy_env = var.deploy_env
}

# Creating associations
resource "aws_eip_association" "eip_ec2_asso" {
  instance_id = module.ec2.output_ec2_id
  allocation_id = module.eip.output_eip_id
}

