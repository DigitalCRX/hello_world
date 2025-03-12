provider "aws" {
  profile = "default"
  region  = "us-east-1"

  access_key = AWS_ACCESS_KEY_ID
  secret_key = AWS_SECRET_ACCESS_KEY
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "aws_hello_sg" {
  name        = "http_in"
  description = "Allow HTTP & HTTPS traffic in port 8888 and everything out"

  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "aws_hello_http_in" {
  type        = "ingress"
  from_port   = 8888
  to_port     = 8888
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.aws_hello_sg.id
}

resource "aws_security_group_rule" "aws_hello_everything_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.aws_hello_sg.id
}

resource "aws_instance" "hello_ec2" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t4g.nano"

  vpc_security_group_ids = [aws_security_group.aws_hello_sg.id]

  tags = {
    Name = "hello_ec2"
  }
}

resource "aws_eip" "hello_eip" {
  instance = aws_instance.hello_ec2.id
  domain   = "vpc"
}
