variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/id_rsa.pub
DESCRIPTION
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "sample_key"
}

variable "region" {
  default = "us-west-2"
}

variable "amis" {
  type = "map"
  default = {
    us-west-2 = "ami-746aba14"
    us-west-1 = "ami-a9a8e4c9"
  }
}

variable vpc_name {
  description = "Name of the VPC"
  default = "sample_vpc"
}

variable control_cidr {
  description = "CIDR block which has full access to provisioned aws resources"
  default = "193.109.118.0/24"
}

variable vpc_cidr {
  default = "10.77.0.0/16"
}

variable aws_zone {
  type = "map"
  default = {
    us-west-2 = "us-west-2a"
    us-west-1 = "us-west-1a"
  }
}

variable "instance_type" {
  default = "t2.micro"
}
