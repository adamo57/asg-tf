terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "terraform"
    key            = "tf-asg"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-dyanmodb"
  }
}