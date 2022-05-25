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

######################################################
#     EC2 Configs
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

resource "aws_eip_association" "test_eip_ass" {
  instance_id   = aws_instance.instance1.id
  allocation_id = aws_eip.test_eip.id
}

resource "aws_eip" "test_eip" {
  vpc = true
}
#data "aws_instance" "instance1" {
#  instance_id = aws_instance.instance1.id
#}
#resource "aws_network_interface_sg_attachment" "sg_attachment" {
#  security_group_id    = aws_security_group.test_sg.id
#  network_interface_id = aws_instance.instance1.network_interface_id

######################################################
#     Network Configs
######################################################

#Default VPC - Unmanaged
#resource "aws_vpc" "main_vpc" {
#  instance_tenancy = "default"
#}

resource "aws_vpc" "test_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    name = "Test VPC"
  }
  #  default_security_group_id = "aws_vpc.test_vpc.default_security_group_id.id"
}

resource "aws_subnet" "test_subnet" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.10.10.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "test_subnet"
  }
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "test_igw"
  }
}

resource "aws_route_table" "test_rt" {
  vpc_id = aws_vpc.test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }
}

resource "aws_route_table_association" "test_rt_ass" {
  subnet_id      = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_rt.id
}

resource "aws_network_acl" "test_nacl" {
  vpc_id     = aws_vpc.test_vpc.id
  subnet_ids = [aws_subnet.test_subnet.id]
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = var.my_ip
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = var.my_ip
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 90
    action     = "allow"
    cidr_block = var.my_ip
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 90
    action     = "allow"
    cidr_block = var.my_ip
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.my_ip
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.my_ip
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.my_ip
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.my_ip
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
}

resource "aws_security_group" "test_sg" {
  name        = "Test-SG"
  description = "Test Security Group"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

######################################################
#     S3 Configs
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

######################################################
#     Variable Configs
######################################################
variable "ami_sydney" {
  default = "ami-0c6120f461d6b39e9"
}

variable "ec2_type" {
  default = "t2.micro"
}

variable "my_ip" {
  default = "117.20.69.72/32"
}

#variable "subnet_10" {
#  default = "10.10.10.0/24"
#}
######################################################
######################################################


######################################################
######################################################
######################################################
