variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  type = string
  default = "ami-0c7af5fe939f2677f"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type = string
  default = "t2.micro"
}
