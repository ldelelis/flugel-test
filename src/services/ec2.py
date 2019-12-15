from .base import AwsService


class EC2Service(AwsService):
    service_name = 'ec2'

    def list_unused_instances(self, tags):
        resources = self.client.describe_instances(
            # Filter out recently terminated instances
            Filters=[
                {
                    'Name': 'instance-state-name',
                    'Values': [
                        'pending',
                        'running',
                        'shutting-down',
                        'stopping',
                        'stopped',
                    ]
                },
            ]
        )
        unused_resources = []
        filters = self._make_filters(tags)

        for reservation in resources['Reservations']:
            for instance in reservation['Instances']:
                # If none of the input tags exist in the instance
                if not any(filt for filt in filters if filt in instance['Tags']):
                    unused_resources.append(instance['InstanceId'])

        return unused_resources
