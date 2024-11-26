variable "instance_type" {
  type = string
  default = "t2.nano"
}

variable "ec2_name_tag" {
  default = {
    Name = "hamid-ec2"
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