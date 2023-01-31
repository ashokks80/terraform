resource "aws_vpc_peering_connection" "vpc-peering" {
  peer_owner_id = "646752868508"
  peer_vpc_id   = var.peerid.default
  vpc_id        = aws_vpc.crud-task.id
  peer_region   = "us-east-1"
  auto_accept = "true"
accepter {
  allow_classic_link_to_remote_vpc = "true"
  allow_remote_vpc_dns_resolution  = "true"
  allow_vpc_to_remote_classic_link = "true"
 }
requester {
  allow_classic_link_to_remote_vpc = "true"
  allow_remote_vpc_dns_resolution  = "true"
  allow_vpc_to_remote_classic_link = "true"
 }
}
