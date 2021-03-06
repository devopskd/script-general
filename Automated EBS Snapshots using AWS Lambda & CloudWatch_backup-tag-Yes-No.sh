# Backup all volumes all regions
# Skip those volumes with tag of Backup=No

import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    
    # Get list of regions
    regions = ec2.describe_regions().get('Regions',[] )

    # Iterate over regions
    for region in regions:
        print "Checking region %s " % region['RegionName']
        reg=region['RegionName']

        # Connect to region
        ec2 = boto3.client('ec2', region_name=reg)
    
        # Get all volumes in all regions  
        result = ec2.describe_volumes()
        
        for volume in result['Volumes']:
            
            backup = 'Yes'
            
            # Get volume tag of Backup if it exists
            for tag in volume['Tags']:
                if tag['Key'] == 'Backup':
                    backup = tag.get('Value')
                    
            # Skip volume if Backup tag is No
            if backup == 'No':
                break
            
            print "Backing up %s in %s" % (volume['VolumeId'], volume['AvailabilityZone'])
        
            # Create snapshot
            result = ec2.create_snapshot(VolumeId=volume['VolumeId'],Description='Created by Lambda backup function ebs-snapshots')
        
            # Get snapshot resource 
            ec2resource = boto3.resource('ec2', region_name=reg)
            snapshot = ec2resource.Snapshot(result['SnapshotId'])
        
            instance_name = 'N/A'
            
            # Fetch instance ID
            instance_id = volume['Attachments'][0]['InstanceId']
            
            # Get instance object using ID
            result = ec2.describe_instances(InstanceIds=[instance_id])
            
            instance = result['Reservations'][0]['Instances'][0]
            
            print instance
            
             # Find name tag for instance
            if 'Tags' in instance:
                for tags in instance['Tags']:
                    if tags["Key"] == 'Name':
                        instance_name = tags["Value"]
            
            # Add volume name to snapshot for easier identification
            snapshot.create_tags(Tags=[{'Key': 'Name','Value': instance_name}])