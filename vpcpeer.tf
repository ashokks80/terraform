# provider "aws" {
#   region     = "us-east-1"
# }

module "single_account_single_region" {
  source  = "grem11n/vpc-peering/aws//examples/single-account-single-region"

  providers = {
    aws.this = aws
    aws.peer = aws
  }

  this_vpc_id = aws_vpc.crud-task.id
  peer_vpc_id = var.peerid.default

  auto_accept_peering = true

  tags = {
    Name        = "tf-single-account-single-region"
    Environment = "Test"
  }
}
