resource "aws_vpc" "prod" {
  cidr_block = "10.10.0.0/16"

  tags = {
    "Name" = "prod"
  }
}