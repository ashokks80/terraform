resource "aws_vpc_peering_connection" "vpc-peering" {
  peer_owner_id = "646752868508"
  peer_vpc_id   = "vpc-0d4e6f0468b8b227a"
  vpc_id        = aws_vpc.crud-task.id
  peer_region   = "us-east-1"
  auto_accept = "true"
accepter {
  allow_remote_vpc_dns_resolution  = "true"
 }
requester {
  allow_remote_vpc_dns_resolution  = "true"
 }
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider                  = "aws.accepter"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc-peering.id}"
  auto_accept               = true
}
