provider "aws" {
  region = "${var.region}"
}

# create VPC for EC2 instances
resource "aws_vpc" "sample_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.vpc_name}"
  }
}

# create single subnet (spans across whole VPC)
resource "aws_subnet" "sample_subnet" {
  vpc_id = "${aws_vpc.sample_vpc.id}"
  cidr_block = "${var.vpc_cidr}"
  availability_zone = "${lookup(var.aws_zone, var.region)}"
}

# create internet gateway for a subnet
resource "aws_internet_gateway" "sample_igw" {
  vpc_id = "${aws_vpc.sample_vpc.id}"
}

# create route table with default route
resource "aws_route_table" "sample_route_table" {
  vpc_id = "${aws_vpc.sample_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.sample_igw.id}"
  }
}

# assosiate routing table with the subnet
resource "aws_route_table_association" "sample_route_assosiation" {
    subnet_id = "${aws_subnet.sample_subnet.id}"
    route_table_id = "${aws_route_table.sample_route_table.id}"
}

# create default security group for VPC
resource "aws_security_group" "sample_sg" {
  vpc_id = "${aws_vpc.sample_vpc.id}"
  name = "default security group"

  # Allow all outgoing traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all incoming traffic from control CIDR
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.control_cidr}"]
  }

  # Allow all internal traffic
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
}

# import keypair
resource "aws_key_pair" "auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

# create a sample instance
resource "aws_instance" "example" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.sample_sg.id}"]
  subnet_id = "${aws_subnet.sample_subnet.id}"
  tags {
    ansibleFilter = "sample"
    ansibleNodeType = "db"
  }

#  provisioner "local-exec" {
#    command = "echo ${aws_instance.example.public_ip} > file.txt"
#  }
}

# assign an elastic ip to an instance
resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

# output assigned IP address
output "ip" {
  value = "${aws_eip.ip.public_ip}"
}
