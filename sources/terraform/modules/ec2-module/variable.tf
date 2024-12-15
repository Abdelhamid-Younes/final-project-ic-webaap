variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "aws_ssh_key" {
  type = string
  default = "devops-hamid"
}

variable "ec2_name_tag" {
  default = {
    Name = "NULL"
  }
}

variable "sg_name" {
  type = string
  description = "Security group name"
  default = "NULL"
}

variable "az" {
    description = "Availability zone of the instance ec2"
    type = string
    default = "us-east-1b"
}

variable "public_ip" {
  type = string
  default = "NULL"
}

variable "user" {
  type = string
  default = "ubuntu"
}