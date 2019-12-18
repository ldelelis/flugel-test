from botocore.client import ClientError

from .base import AwsService


class S3Service(AwsService):
    service_name = 's3'

    def list_unused_instances(self, tags):
        buckets = self.client.list_buckets()
        filters = self._make_filters(tags)
        unused_resources = []

        for bucket in buckets['Buckets']:
            try:
                bucket_tagset = self.client.get_bucket_tagging(Bucket=bucket['Name']).get('TagSet')
                if bucket_tagset:
                    # If none of the input tags exist in the bucket
                    if not any(filt for filt in filters if filt in bucket_tagset):
                        unused_resources.append(bucket['Name'])
            except ClientError:
                continue

        return unused_resources
