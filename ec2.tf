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
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet_3.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.role_ec2.name
  associate_public_ip_address = true
  tags = {
    Name = "node-server"
  }
    depends_on = [aws_apigatewayv2_api.crud-api]
}

resource "aws_instance" "node-server_private" {
  ami                         = aws_ami_from_instance.aws_ami_from_instance.id
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.private_subnet_4.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.role_ec2.name
  associate_public_ip_address = false
#   user_data = file(./roles/node_install/files/ec2-get-api.sh)
  tags = {
    Name = "node-server-private"
  }
    depends_on = [aws_ami_from_instance.aws_ami_from_instance]
    user_data = file("roles/node_install/files/ec2-get-api.sh")
}



resource "aws_iam_instance_profile" "role_ec2" {
  name = "roleec2get"
  role = aws_iam_role.role_ec2_api_get.name
}

resource "aws_iam_role" "role_ec2_api_get" {
  name = "roleec2apiget"
  path = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ec2_policy" {
  name = "ec2_policy"
  path = "/"
  description = "policy to provider permission on ec2"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action =  "*" ,
        Resource = "*"
      }
    ]
})
}

resource "aws_iam_policy_attachment" "ec2_policy_role" {
  name = "ec2_attachment"
  roles = [aws_iam_role.role_ec2_api_get.name]
  policy_arn = aws_iam_policy.ec2_policy.arn
  }
