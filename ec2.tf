resource "aws_instance" "instance1" {
  ami             = var.ami_sydney
  instance_type   = var.ec2_type
  security_groups = ["Test-SG"]
  # vpc_security_group_ids = [aws_security_group.test_sg.id]
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
