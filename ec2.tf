data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "node-server" {
  ami                         = data.aws_ami.ubuntu.id
  #count = 2
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet_3.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "node-server"
  }
    depends_on = [aws_apigatewayv2_api.crud-api]
}

resource "aws_iam_policy" "ec2_api_policy" {
  name        = "ec2_Access"
  description = "ec2_access"
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
              "apigateway:GET"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "ec2_api_role" {
  name        = "api_ec2"
  description = "ec2_access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.ec2_api_role.name
  policy_arn = aws_iam_policy.ec2_api_policy.arn
}
