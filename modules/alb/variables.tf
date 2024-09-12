variable "vpc_id" {

}

variable "alb_name" {}

variable "internal" {
  type    = bool
  default = false
}

variable "load_balancer_type" {
  type = string
  # "application" "network"
  default = "application"
}

variable "security_groups" {
  type = list(any)
}

variable "subnets" {
  type = list(string)
}

variable "alb_tag" {}

# target group variables
variable "tg_name" {}

variable "tg_port" {
  default = 80
}

variable "tg_protocol" {
  default = "HTTP"
}

variable "alb_tg_tag" {}

# aws_lb_listener for http traffic
variable "http_listener_port" {
  default = 80
}

variable "http_listener_protocol" {
  default = "HTTP"
}

variable "http_listener_default_action" {
  default = "forward"
}

# aws_lb_listener for https traffic
variable "https_listener_port" {
  default = 443
}

variable "https_listener_default_action" {
  default = "forward"
}

variable "https_listener_protocol" {
  default = "HTTPS"
}

variable "https_listener_tag" {

}

variable "http_listener_tag" {}

# Target Group Attachment
variable "tg_attachment_port" {
  default = 80
}
