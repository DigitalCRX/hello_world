data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "aws_hello_sg" {
  name        = "aws_hello_sg"
  description = "Allow HTTP traffic over port 8888"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "aws_hello_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.aws_hello_sg.id
  from_port         = var.in_port
  to_port           = var.in_port
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.aws_hello_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_instance" "hello_ec2" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.aws_hello_sg.id]

  user_data = <<-EOF
    yum -y install httpd
    echo "<h1>Hello world</h1>" > /var/www/html/index.html
    sudo systemctl enable httpd
    sudo systemctl start httpd
    EOF

  tags = {
    Name = "hello_ec2"
  }
}

#resource "aws_eip" "hello_eip" {
#  instance = aws_instance.hello_ec2.id
#  domain   = "vpc"
#}

output "DNS" {
  value = aws_instance.hello_ec2.public_dns
}
