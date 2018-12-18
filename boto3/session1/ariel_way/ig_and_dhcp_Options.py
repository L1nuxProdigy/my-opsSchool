#!/usr/bin/python3
import boto3
import argparse

def dhcp_delete(boto_client,dhcp_id):
    dhcps_in_json = client.describe_dhcp_options()
    for dhcp_object in dhcps_in_json['DhcpOptions']:
        if dhcp_object['DhcpOptionsId'] != dhcp_id:
            client.delete_dhcp_options(DhcpOptionsId=dhcp_object['DhcpOptionsId'])

def pick_vpc_id(boto_client):
    array_ids = []
    index = 0
    vpcs_in_json = client.describe_vpcs()
    for vpc_object in vpcs_in_json['Vpcs']:
        array_ids.append(vpc_object['VpcId'])
        print('The VPC Index Is: ',index,' ','and the vpc ID is: ',vpc_object['VpcId'])
        index = index + 1
    i = int(input("Enter an Int to pick a VPC (starting from 0): "))
    choose_id = array_ids[i]
    return choose_id

def arg_parser():
    parser = argparse.ArgumentParser(add_help=True, description="VPC Arguments")
    parser.add_argument("--region", "-r", help="Get target region",required=True)
    return parser.parse_args()

if __name__ == '__main__':
    ## defining resources
    ARGS = arg_parser()
    ec2 = boto3.resource('ec2', region_name=ARGS.region)
    client = boto3.client('ec2', region_name=ARGS.region)
    ## picking a vpc id and defining a vpc resource
    vpc_id = pick_vpc_id(client)
    vpc = ec2.Vpc(vpc_id)
    ## create and attach an IG
    internet_gateway = client.create_internet_gateway()
    internet_gateway_id = internet_gateway['InternetGateway']['InternetGatewayId']
    vpc.attach_internet_gateway(InternetGatewayId=internet_gateway_id)
    ## create and attach DHCP options
    dhcp_create = client.create_dhcp_options(DhcpConfigurations=[{'Key': 'domain-name-servers', 'Values': ['8.8.8.8', '8.8.4.4']}])
    dhcp_options_id = dhcp_create['DhcpOptions']['DhcpOptionsId']
    vpc.associate_dhcp_options(DhcpOptionsId=dhcp_options_id)
    ## Delete all DHCP options (including the default) aside from the one created
    dhcp_delete(client,dhcp_options_id)