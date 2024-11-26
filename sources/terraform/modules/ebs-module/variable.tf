variable "ebs_size" {
  type = number
  default = "5"
}

variable "az" {
    description = "Availability zone of the instance ebs"
    type = string
    default = "us-east-1b"
}

variable "ebs_tag" {
    default = {
      Name = "hamid-ebs"
    }
}