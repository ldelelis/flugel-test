output "aws_instance_unused" {
    value = module.test_instance_1.instance_id
}

output "aws_instance_used" {
    value = module.test_instance_2.instance_id
}

output "s3_bucket_unused" {
    value = module.test_bucket_1.bucket_name
}

output "s3_bucket_used" {
    value = module.test_bucket_2.bucket_name
}