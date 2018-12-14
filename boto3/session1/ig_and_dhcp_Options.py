#!/usr/bin/python3
import boto3

# defining resources
ec2 = boto3.resource('ec2')
client = boto3.client('ec2')

# defining a vpc resource and picking a vpc
print("The amount of existing VPC's: ",len(client.describe_vpcs()['Vpcs']))
pick_vpc = int(input("Enter an Int to pick a VPC (starting from 0): "))
vpc_id = client.describe_vpcs()['Vpcs'][pick_vpc]['VpcId']
vpc = ec2.Vpc(vpc_id)

# creating an IG and picking one
client.create_internet_gateway()
print("The amount of existing IG's: ",len(client.describe_internet_gateways()['InternetGateways']))
pick_IG = int(input("Enter an Int to pick a IG (starting from 0): "))
internet_gateway_id = client.describe_internet_gateways()['InternetGateways'][pick_IG]['InternetGatewayId']
## attach the IG to the VPC
vpc.attach_internet_gateway(InternetGatewayId=internet_gateway_id)

# Create and Attach DHCP options
ec2.create_dhcp_options(DhcpConfigurations=[{'Key': 'domain-name-servers','Values': ['8.8.8.8','8.8.4.4']}])
dhcp_options_id = client.describe_dhcp_options()['DhcpOptions'][0]['DhcpOptionsId']
vpc.associate_dhcp_options(DhcpOptionsId=dhcp_options_id)

# Delete Default Dhcp Options
dhcp_options_id = client.describe_dhcp_options()['DhcpOptions'][1]['DhcpOptionsId']
client.delete_dhcp_options(DhcpOptionsId=dhcp_options_id)