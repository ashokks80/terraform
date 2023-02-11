resource "aws_ami_from_instance" "aws_ami_from_instance" {
  depends_on              = [null_resource.node-server]
  name                    = "Node-server"
  source_instance_id      = aws_instance.node-server.id
  snapshot_without_reboot = true

  tags = {
    Name = "node-ami"
  }
}


resource "aws_launch_configuration" "node-server" {
  name_prefix     = "node-server-lc"
  image_id        = aws_ami_from_instance.aws_ami_from_instance.id
  instance_type   = "t3.medium"
  key_name        = var.key_name
  security_groups = [aws_security_group.ec2_sg.id]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "node-server_private" {
  name_prefix     = "node-server-lb"
  image_id        = aws_ami_from_instance.aws_ami_from_instance.id
  instance_type   = "t3.medium"
  key_name        = var.key_name
  security_groups = [aws_security_group.ec2_sg.id]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_private" {
  name                 = aws_instance.node-server_private.id
  launch_configuration = aws_launch_configuration.node-server_private.id
  min_size             = 1
  max_size             = 4
  vpc_zone_identifier  = [aws_subnet.private_subnet_4.id, aws_subnet.private_subnet_5.id]

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "node-server"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = aws_instance.node-server.id
  launch_configuration = aws_launch_configuration.node-server.name
  min_size             = 1
  max_size             = 4
  vpc_zone_identifier  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "node-server"
    propagate_at_launch = true
  }
}
