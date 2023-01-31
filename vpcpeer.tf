# provider "aws" {
#   region     = "us-east-1"
# }

module "single_account_single_region" {
  source = "../../"

  providers = {
    aws.this = aws
    aws.peer = aws
  }

  this_vpc_id = aws_vpc.crud-task.id
  peer_vpc_id = var.peerid.id

  auto_accept_peering = true

  tags = {
    Name        = "tf-single-account-single-region"
    Environment = "Test"
  }
}
