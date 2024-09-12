resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets
  tags = {
    Name = var.alb_tag
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = var.tg_name
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  tags = {
    Name = var.alb_tg_tag
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.http_listener_port
  protocol          = var.http_listener_protocol

  default_action {
    type             = var.http_listener_default_action
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
  tags = {
    Name = var.http_listener_tag
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.https_listener_port
  protocol          = var.https_listener_protocol

  default_action {
    type             = var.https_listener_default_action
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
  tags = {
    Name = var.https_listener_tag
  }
}




