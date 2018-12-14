#!/usr/bin/python3
import boto3
import argparse

client = boto3.client('ec2')
vpc_id = client.describe_vpcs()['Vpcs'][0]['VpcId']
client.delete_vpc(VpcId=vpc_id)
