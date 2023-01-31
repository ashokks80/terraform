provider "aws" {
  region = var.region
}
resource "aws_vpc" "crud-task" {
  cidr_block = "30.0.0.0/16"

  tags = {
    Name = "crud-task"
  }
}
