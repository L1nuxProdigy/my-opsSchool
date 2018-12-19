#!/usr/bin/python3
import boto3
import configBYariel

client = boto3.client('ec2')
security_group_instance = client.create_security_group(Description=configBYariel.INSTANCE_SG_DESCRIPTION,
                             VpcId=configBYariel.VPC_ID,
                             GroupName=configBYariel.INSTANCE_SG_NAME)
security_group_load_balancer = client.create_security_group(Description=configBYariel.ELB_SG_DESCRIPTION,
                             VpcId=configBYariel.VPC_ID,
                             GroupName=configBYariel.ELB_SG_NAME)
client.authorize_security_group_egress(GroupId)