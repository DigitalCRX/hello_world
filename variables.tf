variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  type = string
  default = ""
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type = string
  default = ""
}
