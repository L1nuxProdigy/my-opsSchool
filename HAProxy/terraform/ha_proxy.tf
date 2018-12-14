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
variable "ha_proxy_path_configured" {}
variable "ha_proxy_path_unconfigured" {}



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

resource "aws_instance" "HA_Proxy_Configured" {
	ami           = "ami-c86c3f23"
	instance_type = "t2.micro"
	key_name        = "${var.key_name}"
	vpc_security_group_ids = ["sg-0bc315224de07ef04"]

	connection {
		user        = "ec2-user"
		private_key = "${file(var.private_key_path)}"
	}
	
	tags = {
	Name = "HA_Proxy_Configured_Terra"
    }

	provisioner "remote-exec" {
		inline = ["${file(var.ha_proxy_path_configured)}"]
	}
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns" {
	value = "${aws_instance.HA_Proxy_Configured.public_dns}"
}
