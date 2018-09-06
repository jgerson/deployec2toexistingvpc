terraform {
  required_version = ">= 0.9.3"
}

# declare provider. This assumes access key and secret key are already set via environment variables

provider "aws" {
  region = "${var.aws_region}"
}

# instance user data 

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.tpl")}"
}

# create ec2
resource "aws_instance" "demo" {
  ami                    = "${var.aws_instance_ami}"
  instance_type          = "${var.aws_instance_type}"
  subnet_id              = "${var.aws_subnetid}"
  vpc_security_group_ids = ["${var.aws_vpc_security_group_ids}"]
  key_name               = "${var.ssh_key_name}"
  user_data              = "${data.template_file.user_data.rendered}"

  root_block_device {
    volume_size = 80
    volume_type = "gp2"
  }

  tags {
    Name  = "${var.service_name}-demo-instance"
    owner = "${var.owner}"
    TTL   = "${var.ttl}"
  }
}

variable "aws_region" {
  description = "AWS region"
  default     = "changeme"
}

variable "aws_subnetid" {
  description = "AWS region"
  default     = "changeme"
}

variable "aws_vpc_security_group_ids" {
  description = "AWS region"
  default     = "changeme"
}

variable "service_name" {
  description = "Unique name to use for DNS"
  default     = "changeme"
}

variable "aws_instance_ami" {
  description = "Amazon Machine Image ID"
  default     = "changeme"
}

variable "aws_instance_type" {
  description = "EC2 instance type"
  default     = "changeme"
}

variable "ssh_key_name" {
  description = "AWS key pair name to install on the EC2 instance"
  default     = "changeme"
}

variable "owner" {
  description = "EC2 instance owner"
  default     = "changeme"
}

variable "ttl" {
  description = "EC2 instance TTL"
  default     = "changeme"
}
