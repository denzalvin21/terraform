#Default VPC - Unmanaged
#resource "aws_vpc" "main_vpc" {
#  instance_tenancy = "default"
#}

resource "aws_vpc" "test_vpc" {
  #  name               = "Test-VPC"
  cidr_block         = "10.10.0.0/16"
  enable_dns_support = "true"
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
