resource "aws_s3_bucket" "crud" {

  bucket = "crud-s3-testing-api"
  acl    = "private" 
  tags = {
    Name        = "s3-crud"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket" "my-bucket-copy" {

  provisioner "local-exec" {
     command = "aws s3 cp lambdafile.zip ${aws_s3_bucket.crud.id}"
  }
}
