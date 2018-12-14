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
variable "prometheus_consul_server_path" {}
variable "grafana_path" {}

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
resource "aws_iam_instance_profile" "Consul_IAM_Profile" {
  name  = "Consul_Profile"
  role = "${aws_iam_role.Consul_IAM_Role.name}"
}

resource "aws_iam_role_policy" "Consul_IAM_Policy" {
  name = "Consul-Describe-Policy"
  role = "${aws_iam_role.Consul_IAM_Role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "Consul_IAM_Role" {
  name = "Consul-Role"
  description = "Created By Terraform"

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
      "Sid": ""
    }
  ]
}
EOF
}

##################################################################################
# VPC Resources
##################################################################################
resource "aws_vpc" "VPC_main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "TRUE"
  tags = {
	Name = "Terraform_VPC"
  }
}

resource "aws_subnet" "Subnet_main" {
  vpc_id     = "${aws_vpc.VPC_main.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "TRUE"

  tags = {
	Name = "Terraform_Subnet"
  }
}

resource "aws_internet_gateway" "IG_main" {
  vpc_id = "${aws_vpc.VPC_main.id}"

  tags = {
    Name = "Terraform_IG"
  }
}

resource "aws_route_table" "Route_Table_main" {
  vpc_id = "${aws_vpc.VPC_main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IG_main.id}"
  }

  tags = {
    Name = "Terraform_Route"
  }
}

resource "aws_main_route_table_association" "VPC_Route_Association" {
  vpc_id         = "${aws_vpc.VPC_main.id}"
  route_table_id = "${aws_route_table.Route_Table_main.id}"
}

resource "aws_route_table_association" "VPC_Subnet_Association" {
  subnet_id      = "${aws_subnet.Subnet_main.id}"
  route_table_id = "${aws_route_table.Route_Table_main.id}"
}

	
resource "aws_security_group" "SecurityGroup_main" {
	name        = "Terraform_SG"
	description = "ssh for now"
	vpc_id      = "${aws_vpc.VPC_main.id}"

	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "TCP"
		cidr_blocks = ["0.0.0.0/0"]
		description = "SSH"
      }
	ingress {
		from_port   = 65433
		to_port     = 65433
		protocol    = "TCP"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Dummy Exporter APP"
      }
	ingress {
		from_port   = 3000
		to_port     = 3000
		protocol    = "TCP"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Grafana"
      }
	ingress {
		from_port   = 9090
		to_port     = 9090
		protocol    = "TCP"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Prometheus"
      }
	ingress {
		from_port   = 8300
		to_port     = 8300
		protocol    = "TCP"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Consul"
	}
	ingress {
		from_port   = 8301
		to_port     = 8301
		protocol    = "TCP"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Consul"
	}
	ingress {
		from_port   = 8500
		to_port     = 8500
		protocol    = "TCP"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Consul Web"
	}
	  
	egress {
		from_port       = 0
		to_port         = 0
		protocol        = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
        
	}
	
	tags = {
    Name = "Terraform_SG"
  }
}
##################################################################################
# Data
##################################################################################

data "template_file" "grafana_with_config" {
	template = "${file("/home/ubuntu/my-opsSchool/middle_project/grafana/datasources.tpl")}"
	vars {
	prometheus_consul_private_ip = "${aws_instance.App_with_Consul_client-1.private_ip}"
	}
}

##################################################################################
# EC2 Resources
##################################################################################

resource "aws_instance" "grafana" {
	ami           = "ami-08182c55a1c188dee"
	instance_type = "t2.micro"
	key_name        = "${var.key_name}"
	subnet_id = "${aws_subnet.Subnet_main.id}"
	vpc_security_group_ids = ["${aws_security_group.SecurityGroup_main.id}"]
	iam_instance_profile = "${aws_iam_instance_profile.Consul_IAM_Profile.name}"

	connection {
		user        = "ubuntu"
		private_key = "${file(var.private_key_path)}"
	}
	
	tags = {
	Name = "Grafana_by_Terraform"
	}
	
	user_data = "${file(var.grafana_path)}"
	
	provisioner "file" {
	content     = "${data.template_file.grafana_with_config.rendered}"
	destination = "/etc/grafana/provisioning/dashboards/prometheus_datasource.yaml"
	}
	
	provisioner "remote-exec" {
		inline = []
	}
}

resource "aws_instance" "App_with_Consul_client-1" {
	ami           = "ami-08182c55a1c188dee"
	instance_type = "t2.micro"
	key_name        = "${var.key_name}"
	subnet_id = "${aws_subnet.Subnet_main.id}"
	vpc_security_group_ids = ["${aws_security_group.SecurityGroup_main.id}"]
	iam_instance_profile = "${aws_iam_instance_profile.Consul_IAM_Profile.name}"
	
	tags = {
	Name = "APP1_by_Terraform"
	}
	
	user_data = "${file(var.user_data_dummy_exporter_path)}"
}


