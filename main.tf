terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.75.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-2"
}

terraform {
  backend "local" {
    path = "../terraform_tfstate_files/terraform.tfstate"
  }
}

#Default S3 Bucket - Unmanaged
#resource "aws_s3_bucket" "importeds3" {
#  bucket = "dennistestbucket123456"
#  versioning {
#    enabled = true
#  }
#}



#resource "aws_s3_bucket_versioning" "mys3bucketver1" {
#  bucket = aws_s3_bucket.mys3bucket1.id
#  versioning_configuration {
#    status = "Enabled"
#  }
#}

#resource "aws_s3_bucket_acl" "mys3bucketacl1" {
#  bucket = aws_s3_bucket.mys3bucket1.id
#  acl    = "private"
#}



#resource "aws_s3_bucket_acl" "mys3bucketacl2" {
#  bucket = aws_s3_bucket.mys3bucket2.id
#  acl    = "private"
#}
#  tags = {
#    Name        = "test bucket"
#    Environment = "Dev"
#  }
#}
