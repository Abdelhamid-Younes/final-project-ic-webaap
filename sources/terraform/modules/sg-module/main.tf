resource "aws_security_group" "allow_http_https_ssh" {
  name = var.sg_name
  description = "Allow http, https and ssh traffic"

  ingress {
    description = "https from VPC"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "http from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "ssh from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description      = "ic-webapp access"
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description      = "odoo access"
    from_port        = 8069
    to_port          = 8069
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    description      = "pgadmin access"
    from_port        = 5050
    to_port          = 5050
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    description      = "postgres access"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "authorize alla outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "ALL"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = ["::/0"]
  }
}