resource "aws_lb_target_group" "node-server" {
  name     = "node-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.crud-task.id
    health_check {
    path                = "/"
    port                = 5000
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "node-server" {
  target_group_arn = aws_lb_target_group.node-server.arn
  target_id        = aws_instance.node-server.id
  port             = 5000
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.node-server.arn
}
