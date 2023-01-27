resource "aws_security_group" "ec2_sg" {
  name        = "allow_ssh"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.crud-task.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2_sg"
  }
}
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  description       = "SSH from any where"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "http" {
  type                     = "ingress"
  description              = "HTTP"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group" "alb_sg" {
  name        = "allow_alb_public_inbound"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.crud-task.id
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_alb_public_inbound"
  }
}
