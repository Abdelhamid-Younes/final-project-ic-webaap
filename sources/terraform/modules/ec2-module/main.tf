data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["014893574759"]

  filter {
    name   = "name"
    values = ["*ubuntu*"]
  }
}

resource "aws_instance" "my_ec2" {
  ami             = data.aws_ami.ubuntu_ami.id
  instance_type   = var.instance_type
  key_name        = "devops-hamid"
  security_groups = ["${var.sg_name}"]
  tags            = var.ec2_name_tag
  availability_zone = var.az

  root_block_device {
    delete_on_termination = true
  }

/*
  provisioner "local-exec" {
    command = "echo PUBLIC IP: ${var.public_ip} >> ec2_IP.txt"
  }
  */
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
     connection {
       type = "ssh"
       user = var.user
       private_key = file("C:/Users/Administrados/devops-hamid.pem")
       host = self.public_ip
     }
  }

}