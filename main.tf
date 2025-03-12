data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "aws_hello_sg" {
  name        = "aws_hello_sg"
  description = "Allow HTTP & HTTPS traffic in port 8888"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = var.in_port
    to_port     = var.in_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "hello_ec2" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.aws_hello_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo echo "<h1>Hello world</h1>" > /var/www/html/index.html
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
