provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["C:/Users/Administrados/aws_credentials"]
}

terraform {
  backend "s3" {
    bucket = "terrafor-backend-hamid"
    key = "nginx-tfstate"
    region = "us-east-1"
    shared_credentials_files = ["C:/Users/Administrados/aws_credentials"]
  }
}

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
  instance_type = "t2.micro"
  public_ip = module.eip.output_eip_ip
  sg_name = module.sg.output_sg_name
}

module "ebs" {
  source = "../modules/ebs-module"
  ebs_size = 5 
}

# Creating associations
resource "aws_eip_association" "eip_ec2_asso" {
  instance_id = module.ec2.output_ec2_id
  allocation_id = module.eip.output_eip_id
}

resource "aws_volume_attachment" "ebs_ec2_attach" {
  volume_id = module.ebs.output_ebs_id
  device_name = "/dev/sdh"
  instance_id = module.ec2.output_ec2_id
}