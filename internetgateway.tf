resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.crud-task.id

  tags = {
    Name = "igw"
  }
}
