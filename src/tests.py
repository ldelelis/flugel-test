import json
import os
import unittest

from main import filter_aws_resources


instances = {}


class AwsTagFilterTestCase(unittest.TestCase):
    def test_unused_filter_returns_non_matching_resources(self):
        tags = ['unused:true']

        result = filter_aws_resources(tags)

        self.assertEqual(len(result['ec2']), 1)
        self.assertEqual(len(result['s3']), 1)
        self.assertEqual(result['ec2'][0], instances['aws_instance_used']['value'])
        self.assertEqual(result['s3'][0], instances['s3_bucket_used']['value'])

    def test_non_existent_tag_returns_all_resources(self):
        tags = ['unused:a value that is unlikely to exist']
        expected_ec2_ids = [
            instances['aws_instance_used']['value'],
            instances['aws_instance_unused']['value'],
        ]
        expected_s3_buckets = [
            instances['s3_bucket_used']['value'],
            instances['s3_bucket_unused']['value'],
        ]

        result = filter_aws_resources(tags)

        self.assertEqual(len(result['ec2']), 2)
        self.assertEqual(len(result['s3']), 2)
        self.assertEqual(result['ec2'].sort(), expected_ec2_ids.sort())
        self.assertEqual(result['s3'].sort(), expected_s3_buckets.sort())

    def test_all_matching_tags_returns_no_resources(self):
        tags = ['unused:true', 'unused:false']

        result = filter_aws_resources(tags)

        self.assertEqual(len(result['ec2']), 0)
        self.assertEqual(len(result['s3']), 0)


if __name__ == '__main__':
    instances.update(json.loads(os.getenv('TERRAFORM_OUTPUT', '{}')))
    unittest.main()
