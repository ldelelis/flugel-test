output "bucket_name" {
    value = aws_s3_bucket.test_bucket.bucket
    description = "Bucket auto-generated name."
}
