##################################################################################
# VARIABLES
##################################################################################

### Connection Vars ###
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {
  default = "Visibility"
}

### Machines Configurations Scripts ###
variable "AMI" {}



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

resource "aws_instance" "ansible_server" {
	ami           = "ami-0bdf93799014acdc4"
	instance_type = "t2.micro"
	key_name        = "${var.key_name}"
	vpc_security_group_ids = ["sg-02e7cd2c6090514d4"]

	
	tags = {
	Name = "Terra_AMI"
    }

	user_data = "${file(var.AMI)}"

}