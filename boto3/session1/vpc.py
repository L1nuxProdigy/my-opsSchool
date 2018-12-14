#!/usr/bin/python3
import boto3
import argparse

ec2 = boto3.resource('ec2')
vpc = ec2.create_vpc(CidrBlock='172.16.0.0/16',InstanceTenancy='default')
