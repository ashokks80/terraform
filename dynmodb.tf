resource "aws_dynamodb_table" "learn-crud" {
  name           = "learn-crud"
  hash_key       = "id"
  read_capacity  = 2
  write_capacity = 2

  attribute {
    name = "id"
    type = "S"
  }

  # ttl {
  #   attribute_name = "TimeToExist"
  #   enabled        = false
  # }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}
