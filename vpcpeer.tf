resource "aws_vpc_peering_connection" "vpc-peering" {
  peer_owner_id = "646752868508"
  peer_vpc_id   = var.peerid.default
  vpc_id        = aws_vpc.crud-task.id
  peer_region   = "us-east-1"
}
