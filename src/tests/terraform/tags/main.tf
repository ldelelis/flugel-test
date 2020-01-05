terraform {
  required_version = ">=0.12.0"
}

provider "aws" {
  profile = "flugel"
  region  = "us-east-1"
}

module "test_instance_1" {
  source = "../modules/ec2"

  is_unused = "true"
}

module "test_instance_2" {
  source = "../modules/ec2"

  is_unused = "false"
}

module "test_bucket_1" {
  source = "../modules/s3"

  is_unused = "true"
}

module "test_bucket_2" {
  source = "../modules/s3"

  is_unused = "false"
}
