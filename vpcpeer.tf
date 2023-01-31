resource "aws_vpc_peering_connection" "vpc-peering" {
  peer_owner_id = "646752868508"
  peer_vpc_id   = "vpc-0d4e6f0468b8b227a"
  vpc_id        = aws_vpc.crud-task.id
  peer_region   = "us-east-1"
accepter {
  allow_remote_vpc_dns_resolution  = "true"
 }
requester {
  allow_remote_vpc_dns_resolution  = "true"
 }
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc-peering.id}"
  auto_accept               = true
}


data "aws_route_tables" "accepter" {
  vpc_id = "${aws_vpc.crud-task.id}"
}

data "aws_route_tables" "owner" {
  vpc_id = "vpc-0d4e6f0468b8b227a"
}


resource "aws_route" "owner" {
  count = "${length(data.aws_route_tables.owner.ids)}"
  route_table_id            = "${data.aws_route_tables.owner.ids[count.index]}"
  destination_cidr_block    = "${data.aws_vpc.accepter.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.owner.id}"
}   

resource "aws_route" "accepter" {
  count = "${length(data.aws_route_tables.accepter.ids)}"
  route_table_id            = "${data.aws_route_tables.accepter.ids[count.index]}"
  destination_cidr_block    = "${data.aws_vpc.owner.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.owner.id}"
}
