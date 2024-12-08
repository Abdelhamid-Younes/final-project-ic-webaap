resource "aws_eip" "my_eip" {
    domain = "vpc"

    provisioner "local-exec" {
        command = "echo IP: ${aws_eip.my_eip.public_ip} > /var/jenkins_home/workspace/ic-webapp@2/ec2_IP.txt"
    }
}


