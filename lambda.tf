resource "aws_iam_role" "iam_for_lambda_dynamo" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
      "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dynamo_db_access" {
    name = "dynamo-db-access"
    role = aws_iam_role.iam_for_lambda_dynamo.id
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_lambda_function" "learn-crud" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambdafile.zip"
  function_name = "learn-crud"
  role          = aws_iam_role.iam_for_lambda_dynamo.arn
#   handler       = "index.mjs"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
#   source_code_hash = filebase64sha256("index.mjs")

  runtime = "nodejs18.x"

  environment {
    variables = {
      foo = "leran-crud"
    }
  }
}
