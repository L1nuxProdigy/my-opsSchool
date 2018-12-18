#!/usr/bin/python3
import boto3
import argparse

ec2 = boto3.resource('ec2')
client = boto3.client('ec2')
waiter = client.get_waiter('nat_gateway_available')

#Creating 2 Subnets in a VPC
vpc_id = client.describe_vpcs()['Vpcs'][0]['VpcId']
private_subnet = ec2.create_subnet(AvailabilityZoneId='euw3-az3',CidrBlock='10.21.1.0/24',VpcId=vpc_id)
private_subnet_id = client.describe_subnets(Filters=[{'Name': 'cidr-block','Values': ['10.21.1.0/24']}])['Subnets'][0]['SubnetId']
public_subnet = ec2.create_subnet(AvailabilityZoneId='euw3-az3',CidrBlock='10.21.2.0/24',VpcId=vpc_id)
private_subnet.create_tags(Tags=[{'Key': 'Name','Value': 'Private_1c'}])
public_subnet.create_tags(Tags=[{'Key': 'Name','Value': 'Public_1c'}])
public_subnet_id = client.describe_subnets(Filters=[{'Name': 'cidr-block','Values': ['10.21.2.0/24']}])['Subnets'][0]['SubnetId']

#Nat and elastic IP
client.allocate_address()
elastic_ip_id =  client.describe_addresses()['Addresses'][0]['AllocationId']
public_subnet_id = client.describe_subnets(Filters=[{'Name': 'tag:Name','Values':['Public_1c']}])['Subnets'][0]['SubnetId']
nat_gateway_id = client.create_nat_gateway(AllocationId=elastic_ip_id,SubnetId=public_subnet_id)['NatGateway']['NatGatewayId']
waiter.wait(Filters=[{'Name': 'nat-gateway-id','Values': [nat_gateway_id]}])

#Route Tables
internet_gateway_id = client.describe_internet_gateways()['InternetGateways'][0]['InternetGatewayId']
nat_gateway_id = client.describe_nat_gateways(Filters=[{'Name': 'state','Values': ['available','pending']}])['NatGateways'][0]['NatGatewayId']
public_route_table = client.create_route_table(VpcId=vpc_id)
public_route_table_id = public_route_table['RouteTable']['RouteTableId']
client.create_route(DestinationCidrBlock='0.0.0.0/0',GatewayId=internet_gateway_id,RouteTableId=public_route_table_id)
client.associate_route_table(RouteTableId=public_route_table_id,SubnetId=public_subnet_id)
public_route_table_resource = ec2.RouteTable(public_route_table_id)
public_route_table_resource.create_tags(Tags=[{'Key': 'Name','Value': 'Public_1c'}])

private_route_table = client.create_route_table(VpcId=vpc_id)
private_route_table_id = private_route_table['RouteTable']['RouteTableId']
client.create_route(DestinationCidrBlock='0.0.0.0/0',GatewayId=nat_gateway_id,RouteTableId=private_route_table_id)
client.associate_route_table(RouteTableId=private_route_table_id,SubnetId=private_subnet_id)
private_route_table_resource = ec2.RouteTable(private_route_table_id)
private_route_table_resource.create_tags(Tags=[{'Key': 'Name','Value': 'Private_1c'}])