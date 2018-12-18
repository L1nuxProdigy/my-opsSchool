#!/usr/bin/python3
import boto3
import argparse
import time

client = boto3.client('ec2')
ec2 = boto3.resource('ec2')

# delete the nat gateway and release the elastic ip address
nat_gateway_id = client.describe_nat_gateways(Filters=[{'Name': 'state','Values': ['available','pending']}])['NatGateways'][0]['NatGatewayId']
client.delete_nat_gateway(NatGatewayId=nat_gateway_id)
while client.describe_nat_gateways(Filters=[{'Name': 'nat-gateway-id','Values': [nat_gateway_id]}])['NatGateways'][0]['State'] != 'deleted':
    time.sleep(5)
elastic_ip_allocation_id =  client.describe_addresses()['Addresses'][0]['AllocationId']
client.release_address(AllocationId=elastic_ip_allocation_id)

# delete route tables
times_to_loop = len(client.describe_route_tables()['RouteTables'])
route_table_id = []
for i in range(0,times_to_loop):
    if client.describe_route_tables()['RouteTables'][i]['Associations'][0]['Main'] == False:
        table_association_id = client.describe_route_tables()['RouteTables'][i]['Associations'][0]['RouteTableAssociationId']
        client.disassociate_route_table(AssociationId=table_association_id)
        route_table_id.append(client.describe_route_tables()['RouteTables'][i]['RouteTableId'])

times_to_loop = len(route_table_id)
for i in range(0,times_to_loop):
    client.delete_route_table(RouteTableId=route_table_id[i])

# deletes all existing subnets
times_to_loop = len(client.describe_subnets()['Subnets'])
for i in range(0,times_to_loop):
    subnet_id = client.describe_subnets()['Subnets'][0]['SubnetId']
    client.delete_subnet(SubnetId=subnet_id)

vpc_id = client.describe_vpcs()['Vpcs'][0]['VpcId']
vpc = ec2.Vpc(vpc_id)

if len(client.describe_internet_gateways()['InternetGateways']) > 0:
    vpc_id = client.describe_internet_gateways()['InternetGateways'][0]['Attachments'][0]['VpcId']
    internet_gateway_id = client.describe_internet_gateways()['InternetGateways'][0]['InternetGatewayId']
    vpc = ec2.Vpc(vpc_id)
    vpc.detach_internet_gateway(InternetGatewayId=internet_gateway_id)
    client.delete_internet_gateway(InternetGatewayId=internet_gateway_id)

client.delete_vpc(VpcId=vpc_id)
dhcp_options_id = client.describe_dhcp_options()['DhcpOptions'][0]['DhcpOptionsId']
client.delete_dhcp_options(DhcpOptionsId=dhcp_options_id)