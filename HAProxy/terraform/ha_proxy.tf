##################################################################################
# VARIABLES
##################################################################################

### Connection Vars ###
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {
  default = "RedHat"
}

### Machines Configurations Scripts ###
variable "ansible_server_script" {}
variable "ansible_node_script" {}



##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-central-1"
}

##################################################################################
# EC2 Resources
##################################################################################

resource "aws_instance" "HA_Proxy" {
	ami           = "ami-c86c3f23"
	instance_type = "t2.micro"
	key_name        = "${var.key_name}"
	vpc_security_group_ids = ["sg-02e7cd2c6090514d4"]

	connection {
		user        = "ec2-user"
		private_key = "${file(var.private_key_path)}"
	}
	
	tags = {
	Name = "Terra_Ansible_Server"
    }

	provisioner "remote-exec" {
		inline = ["${file(var.ansible_server_script)}"]
	}
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns" {
	value = "${aws_instance.HA_Proxy.public_dns}"
}
