##################################################################################
# VARIABLES
##################################################################################

### Connection Vars ###
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {
  default = "paris"
}

### Machines Configurations Scripts ###
variable "user_data_dummy_exporter_path" {}
variable "consul_client_path" {}
variable "consul_server_path" {}
variable "consul_clean_path" {}



##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-west-3"
}

##################################################################################
# IAM Resources
##################################################################################
resource "aws_iam_policy" "policy" {
  name        = "Describe-For-Consul"
  path        = "/"
  description = "Name Explenatory"
  role = "${aws_iam_role.test_role.id}

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "test_role" {
  name = "test_role"
  description = "Testing"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
    }
  ]
}
EOF

  tags = {
      Name = "Created_by_Terraform"
  }
}
