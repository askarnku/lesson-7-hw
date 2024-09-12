module "hw7_vpc" {
  source = "./modules/vpc"

  vpc_cidr   = "10.0.0.0/24"
  vpc_tag    = "hw7_vpc"
  create_igw = true
  igw_tag    = "hw7"
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.hw7_vpc.vpc_id
  subnets = [
    {
      cidr_block    = "10.0.0.0/26"
      az            = "us-east-1a"
      map_public_ip = true
      tag           = "public_1a"
    },
    {
      cidr_block    = "10.0.0.64/26"
      az            = "us-east-1a"
      map_public_ip = false
      tag           = "private_1a"
    },
    {
      cidr_block    = "10.0.0.128/26"
      az            = "us-east-1b"
      map_public_ip = true
      tag           = "public_1b"
    },
    {
      cidr_block    = "10.0.0.192/26"
      az            = "us-east-1b"
      map_public_ip = false
      tag           = "private_1b"
    },
  ]
}

module "hw7_nat" {
  source = "./modules/nat"

  subnet_id  = module.subnets.subnet_ids[0]
  nat_gw_tag = "hw7_nat"
}

module "public_rtb" {
  source = "./modules/rtb"

  vpc_id    = module.hw7_vpc.vpc_id
  igw_id    = module.hw7_vpc.igw_id
  nat_gw_id = null
  subnets   = [for subnet in module.subnets.subnets : subnet.id if subnet.map_public_ip_on_launch]
}

module "private_rtb" {
  source = "./modules/rtb"

  vpc_id    = module.hw7_vpc.vpc_id
  igw_id    = null
  nat_gw_id = module.hw7_nat.nat_gw_id
  subnets   = [for subnet in module.subnets.subnets : subnet.id if !subnet.map_public_ip_on_launch]
}

module "public_sg" {
  source      = "./modules/sg"
  vpc_id      = module.hw7_vpc.vpc_id
  description = "allows public access on ports 22 80 443"
  sgrp_name   = "public_access_sg"

  ingress_rules = [{
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  # egress_rules = []

  sgrp_tag = "http_ssh_sg"
}

module "private_sg" {
  source      = "./modules/sg"
  vpc_id      = module.hw7_vpc.vpc_id
  description = "allows ssh within vpc cidr"
  sgrp_name   = "private_access_sg"

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/24"]
    }
  ]

  # egress_rules = []

  sgrp_tag = "http_ssh_sg"
}

module "public_ec2" {
  source          = "./modules/ec2"
  ami             = null
  instance_type   = "t2.micro"
  subnet_ids      = [for subnet in module.subnets.subnets : subnet.id if subnet.map_public_ip_on_launch]
  ec2_tag         = "public_instance"
  security_groups = [module.public_sg.security_group_id]
  key_name        = "id_ed25519"
}

module "alb_sg" {
  source = "./modules/sg"

  vpc_id      = module.hw7_vpc.igw_id
  description = "HTTP and HTTPS traffic to alb"
  sgrp_name   = "alb-sg"
  sgrp_tag    = "alb_sg"

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

module "alb" {
  source = "./modules/alb"

  vpc_id          = module.hw7_vpc.vpc_id
  alb_name        = "alb"
  security_groups = [module.alb_sg.security_group_id]
  subnets         = []
  alb_tag         = "alb"

  # target group
  tg_name    = "alb-tg"
  alb_tg_tag = "alb_tg"

  # http_listener
  http_listener_tag = "http_listener"

  # https listner
  https_listener_tag = "https_listener"
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  for_each = {
    for idx, instance_id in module.public_ec2.ec2_ids :
    idx => instance_id
  }

  target_group_arn = module.alb.alb_tg_arn
  target_id        = each.value
  port             = 80
}

