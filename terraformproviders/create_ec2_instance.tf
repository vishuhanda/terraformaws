terraform {

  backend "s3" {
    bucket                   = "demoterraformstate"
    key                      = "key/terraform.tfstate"
    region                   = "ap-south-1"
    profile                  = "default"
    shared_credentials_files = ["/Users/vishuhanda/Desktop/Practice Devops/terraformprac/.aws/credentials"]
  }

}


variable "instance_tag_names" {
  type        = list(any)
  description = "Ec2 instances tag names"
  default     = ["Ec2 first", "Ec2 second", "Ec2 third"]
}

provider "aws" {
  shared_credentials_files = ["/Users/vishuhanda/Desktop/Practice Devops/terraformprac/.aws/credentials"]
  profile                  = "default"
}


resource "aws_instance" "ec2_instance" {

  ami                         = "ami-007020fd9c84e18c7"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  count                       = length(var.instance_tag_names)
  tags = {
    Name = var.instance_tag_names[count.index]
  }

}

output "list_availibility_zones" {
  value = aws_instance.ec2_instance[*].availability_zone
}
output "list_amis" {
  value = aws_instance.ec2_instance[*].ami
}
output "list_public_ips" {
  value = aws_instance.ec2_instance[*].public_ip
}

output "list_private_ips" {
  value = aws_instance.ec2_instance[*].private_ip
}

output "list_instance_state" {
  value = aws_instance.ec2_instance[*].instance_state
}


output "vpc_security_grps" {
  value = aws_instance.ec2_instance[*].vpc_security_group_ids
}