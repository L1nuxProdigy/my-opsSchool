{
    'Vpcs': [{
        'CidrBlock': '172.16.0.0/16',
        'DhcpOptionsId': 'dopt-07c1acc6fa8d6e256',
        'State': 'available',
        'VpcId': 'vpc-0c2364dc66737e2c8',
        'OwnerId': '920354577513',
        'InstanceTenancy': 'default',
        'CidrBlockAssociationSet': [{
            'AssociationId': 'vpc-cidr-assoc-01d3ea4c620884f94',
            'CidrBlock': '172.16.0.0/16',
            'CidrBlockState': {
                'State': 'associated'
            }
        }],
        'IsDefault': False,
        'Tags': [{
            'Key': 'Name',
            'Value': 'VPC_opsschool1'
        }]
    }, {
        'CidrBlock': '172.16.0.0/16',
        'DhcpOptionsId': 'dopt-07c1acc6fa8d6e256',
        'State': 'available',
        'VpcId': 'vpc-06510617ee6fb9fa2',
        'OwnerId': '920354577513',
        'InstanceTenancy': 'default',
        'CidrBlockAssociationSet': [{
            'AssociationId': 'vpc-cidr-assoc-0d7916932c31be378',
            'CidrBlock': '172.16.0.0/16',
            'CidrBlockState': {
                'State': 'associated'
            }
        }],
        'IsDefault': False,
        'Tags': [{
            'Key': 'Name',
            'Value': 'VPC_opsschool1'
        }]
    }],
    'ResponseMetadata': {
        'RequestId': 'd90d455d-d164-49c5-a120-3ef8be65ed27',
        'HTTPStatusCode': 200,
        'HTTPHeaders': {
            'content-type': 'text/xml;charset=UTF-8',
            'content-length': '2101',
            'vary': 'Accept-Encoding',
            'date': 'Fri, 14 Dec 2018 14:33:37 GMT',
            'server': 'AmazonEC2'
        },
        'RetryAttempts': 0
    }
}


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












{
    'Vpcs': [{
        'CidrBlock': '172.16.0.0/16',
        'DhcpOptionsId': 'dopt-07c1acc6fa8d6e256',
        'State': 'available',
        'VpcId': 'vpc-076c0ccb1ea747264',
        'OwnerId': '920354577513',
        'InstanceTenancy': 'default',
        'CidrBlockAssociationSet': [{
            'AssociationId': 'vpc-cidr-assoc-0508a6e9a5edf0ea1',
            'CidrBlock': '172.16.0.0/16',
            'CidrBlockState': {
                'State': 'associated'
            }
        }],
        'IsDefault': False,
        'Tags': [{
            'Key': 'Name',
            'Value': 'VPC_opsschool1'
        }]
    }],
    'ResponseMetadata': {
        'RequestId': '1f87e71d-0a1a-4ce9-9fae-4ce0246baba0',
        'HTTPStatusCode': 200,
        'HTTPHeaders': {
            'content-type': 'text/xml;charset=UTF-8',
            'content-length': '1163',
            'date': 'Fri, 14 Dec 2018 14:41:56 GMT',
            'server': 'AmazonEC2'
        },
        'RetryAttempts': 0
    }
}


{
    'InternetGateways': [{
        'Attachments': [],
        'InternetGatewayId': 'igw-055552a8473e2a0eb',
        'OwnerId': '920354577513',
        'Tags': []
    }],
    'ResponseMetadata': {
        'RequestId': '352608ad-94a1-4b0e-83ff-612c076a4b9d',
        'HTTPStatusCode': 200,
        'HTTPHeaders': {
            'content-type': 'text/xml;charset=UTF-8',
            'content-length': '472',
            'date': 'Fri, 14 Dec 2018 15:15:07 GMT',
            'server': 'AmazonEC2'
        },
        'RetryAttempts': 0
    }
}

{
    'DhcpOptions': [{
        'DhcpConfigurations': [{
            'Key': 'domain-name',
            'Values': [{
                'Value': 'eu-west-3.compute.internal'
            }]
        }, {
            'Key': 'domain-name-servers',
            'Values': [{
                'Value': 'AmazonProvidedDNS'
            }]
        }],
        'DhcpOptionsId': 'dopt-07c1acc6fa8d6e256',
        'OwnerId': '920354577513'
    }],
    'ResponseMetadata': {
        'RequestId': 'bdcd4a51-c9fd-42a1-9eda-fc772b20b7c1',
        'HTTPStatusCode': 200,
        'HTTPHeaders': {
            'content-type': 'text/xml;charset=UTF-8',
            'content-length': '1038',
            'date': 'Fri, 14 Dec 2018 20:54:06 GMT',
            'server': 'AmazonEC2'
        },
        'RetryAttempts': 0
    }
}