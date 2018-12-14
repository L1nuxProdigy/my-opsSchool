#!/usr/bin/python3
import boto3
import argparse

def arg_parser():
    parser = argparse.ArgumentParser(add_help=True, description="VPC Arguments")
    parser.add_argument("--region", "-r", help="Get target region",required=True)
    parser.add_argument("--cidr", "-c", help="Get vpc cidr",required=True)
    parser.add_argument("--tenancy", "-t", help="Get vpc default tenancy",choices=["default", "dedicated", "host"],required=True)
    return parser.parse_args()


if __name__ == '__main__':
    ARGS = arg_parser()
    ec2 = boto3.resource('ec2',region_name=ARGS.region)
    vpc = ec2.create_vpc(CidrBlock=ARGS.cidr, InstanceTenancy=ARGS.tenancy)
    vpc.wait_until_exists
    tag = vpc.create_tags(Tags=[{'Key': 'Name', 'Value': 'VPC_opsschool1'}])