data "aws_ami" "ubuntu_18_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AWS Account ID
}


resource "aws_instance" "icwebapp_ec2" {
  ami             = data.aws_ami.ubuntu_18_ami.id
  instance_type   = var.instance_type
  key_name        = var.aws_ssh_key
  security_groups = ["${var.sg_name}"]
  tags            = var.ec2_name_tag
  availability_zone = var.az

  # provisioner "local-exec" {
  #   command = "echo IP: ${var.public_ip} > ec2_ip.txt"
  # }
  
  root_block_device {
    delete_on_termination = true
  }
  
}