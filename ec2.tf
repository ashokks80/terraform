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

resource "aws_iam_instance_profile" "roleec2" {
  name = "roleec2get"
  role = aws_iam_role.role-ec2apiget.name
}

resource "aws_iam_role" "roleec2apiget" {
  name = "ec2apiget"
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
