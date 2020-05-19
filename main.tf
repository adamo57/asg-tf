locals {
    ami-id = "ami-07ebfd5b3428b6f4d" // ubuntu 16.04
}

resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "prod"
  }
}

resource "aws_subnet" "prod-private-us-east-1c" {
  vpc_id     = aws_vpc.prod.id
  cidr_block = "10.0.22.0/23"

  map_public_ip_on_launch = false

  tags = {
    "Name" = "prod private us-east-1c"
  }
}

resource "aws_security_group" "default" {
  name        = "default_web"
  description = "SG for web service"
  vpc_id      = aws_vpc.prod.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = locals.ami_id
  instance_type = "t2.micro"
  availabilitity_zone = "us-east-1c"
  security_group = aws_security_group.default.id
  subnet_id = aws_subnet.prod-private-us-east-1c.id
}

module "lb-logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "lb-logs"
  acl    = ""
}

resource "aws_lb" "prod-ws-lb" {
  name               = "prod-ws-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.default.id]
  subnets            = [var.subnet_public.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = module.lb-logs.aws_s3_bucket.this.bucket
    prefix  = "prod-ws-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}