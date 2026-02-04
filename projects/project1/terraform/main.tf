terraform{
	required_providers{
		aws = {
			source = "hashicorp/aws"
			version = "~>5.0"
		}
	}

	backend "s3" {
		key="aws/ec2-deploy/terraform.tfstate"
	}
}

provider "aws" {
	region = var.region
}

resource "aws_instance" "server"{
	ami = "ami-ahbwuhf4oh43h"
	instance_type = "t2.micro"
	key_name = aws_key_pair.key_pair.key_name
	vpc_security_group_ids = [aws_security_group.security_group.id]
	iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
	connection {
		type = "ssh"
		host = self.public_ip
		user = "ubuntu"
		private_key = var.private_key
		timeout = "4m"
	}

	tags = {
		name = "deploy_vm"
	}
}

resource "aws_iam_instance_profile" "ec2_profile"{
	name = "ec2_profile"
	role = "ec2_iam"
}

resource "aws_security_group" "security_group"{
	egress = [
		{
			cidr_blocks = ["0.0.0.0/0",]
			description = ""
			from_port = 0
			ipv6_cidr_blocks = []
			security_groups = []
			protocol = "-1"
			prefix_list_ids = []
			self = false
			to_port = 0
		}
	]

	ingress = [
		{
			cidr_blocks = ["0.0.0.0/0",]
			description = ""
			from_port = 22
			ipv6_cidr_blocks = []
			protocol = "tcp"
			security_groups = []
			prefix_list_ids = []
			self = false
			to_port = 22
		},
		{
			cidr_blocks = ["0.0.0.0/0",]
			description = ""
			from_port = 80
			ipv6_cidr_blocks = []
			protocol = "tcp"
			security_groups = []
			prefix_list_ids = []
			self = false
			to_port = 80
		}
	]
}

resource "aws_key_pair" "key_pair"{
	key_name = var.key_name
	public_key = var.public_key
}


output "instance_public_ip"{
	value = aws_instance.server.public_ip
	sensitive = true
}