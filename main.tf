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

######################EC2 Configs#####################
######################################################
resource "aws_instance" "instance1" {
  ami                    = var.ami_sydney
  instance_type          = var.ec2_type
  subnet_id              = aws_subnet.test_subnet.id
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  #security_groups = [aws_security_group.test_sg.id]
  # subnet_id              = aws_vpc.test_vpc.id
  # security_groups = aws_vpc.test_vpc.default_security_group_id.id
  #  depends_on      = [aws_vpc.test_vpc]
}

#data "aws_instance" "instance1" {
#  instance_id = aws_instance.instance1.id
#}
#resource "aws_network_interface_sg_attachment" "sg_attachment" {
#  security_group_id    = aws_security_group.test_sg.id
#  network_interface_id = aws_instance.instance1.network_interface_id

#################Network Configs######################
######################################################

#Default VPC - Unmanaged
#resource "aws_vpc" "main_vpc" {
#  instance_tenancy = "default"
#}

resource "aws_vpc" "test_vpc" {
  cidr_block         = "10.10.0.0/16"
  enable_dns_support = "true"

  tags = {
    name = "Test VPC"
  }
  #  default_security_group_id = "aws_vpc.test_vpc.default_security_group_id.id"
}

resource "aws_subnet" "test_subnet" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = "10.10.10.0/24"
  #  depends_on = [aws_vpc.test_vpc]
}

resource "aws_security_group" "test_sg" {
  name   = "Test-SG"
  vpc_id = aws_vpc.test_vpc.id
  #  depends_on = [aws_vpc.test_vpc]
}
##################S3 Configs##########################
######################################################

#Test S3 Bucket
resource "aws_s3_bucket" "tests3" {
  bucket = "dennis-terraform-test"
}

resource "aws_s3_bucket_versioning" "tests3ver" {
  bucket = aws_s3_bucket.tests3.id

  versioning_configuration {
    status = "Enabled"
  }
}

#  versioning {
#    enabled = true
#  }

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
#################Variable Config######################
######################################################
variable "ami_sydney" {
  default = "ami-0c6120f461d6b39e9"
}

variable "ec2_type" {
  default = "t2.micro"
}

#variable "subnet_10" {
#  default = "10.10.10.0/24"
#}
######################################################
######################################################



######################################################
######################################################
