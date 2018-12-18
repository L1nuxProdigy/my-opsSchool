#!/usr/bin/python3
import boto3
import argparse

# defining resources
ec2 = boto3.resource('ec2')
client = boto3.client('ec2')

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
