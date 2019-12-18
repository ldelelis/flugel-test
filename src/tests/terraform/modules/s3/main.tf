variable "is_unused" {
  type = string
}

resource "random_uuid" "test_bucket_name" { }

resource "aws_s3_bucket" "test_bucket" {
  bucket = random_uuid.test_bucket_name.result
  acl    = "private"

  tags = {
    unused = var.is_unused
  }
}