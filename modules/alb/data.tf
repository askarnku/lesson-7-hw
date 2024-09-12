data "aws_lb" "alb_arn" {
  arn = aws_lb.alb.arn
}

data "aws_lb_target_group" "alb_tg_id" {
  arn = aws_lb_target_group.alb_tg.arn
}
