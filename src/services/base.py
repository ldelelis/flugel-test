import os

import boto3


class AwsService:
    service_name = None

    def __init__(self):
        self.session = boto3.Session(
            profile_name=os.getenv('AWS_PROFILE_NAME', None)
        )
        self.client = self.session.client(
            self.service_name
        )

    def _make_filters(self, tags):
        # Convert tag pairs to AWS-format dicts
        filters = []
        for tag in tags:
            key, value = tag.split(':')
            filters.append({'Key': key, 'Value': value})

        return filters

    def list_unused_instances(self, tags):
        raise NotImplementedError()
