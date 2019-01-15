##################################################################################
# VARIABLES
##################################################################################

### Connection Vars ###
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {
  default = "New"
}

### Machines Configurations Scripts ###
variable "percona_script_path" {}




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

resource "aws_instance" "percona" {
	ami           = "ami-0bdf93799014acdc4"
	instance_type = "t2.micro"
	key_name        = "${var.key_name}"
	vpc_security_group_ids = ["sg-02e7cd2c6090514d4"]

	
	tags = {
	Name = "Percona_by_Terraform"
    }
	
	user_data = "${file(var.percona_script_path)}"
	
}