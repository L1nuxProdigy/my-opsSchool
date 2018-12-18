#!/usr/bin/python3
import boto3
import argparse
import time

client = boto3.client('ec2')

# delete the nat gateway and release the elastic ip address
nat_gateway_id = client.describe_nat_gateways(Filters=[{'Name': 'state','Values': ['available','pending']}])['NatGateways'][0]['NatGatewayId']
client.delete_nat_gateway(NatGatewayId=nat_gateway_id)
while client.describe_nat_gateways(Filters=[{'Name': 'nat-gateway-id','Values': [nat_gateway_id]}])['NatGateways'][0]['State'] != 'deleted':
    time.sleep(5)
elastic_ip_allocation_id =  client.describe_addresses()['Addresses'][0]['AllocationId']
client.release_address(AllocationId=elastic_ip_allocation_id)

# deletes all existing subnets
times_to_loop = len(client.describe_subnets()['Subnets'])
for i in range(0,times_to_loop):
    subnet_id = client.describe_subnets()['Subnets'][0]['SubnetId']
    client.delete_subnet(SubnetId=subnet_id)