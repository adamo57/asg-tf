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