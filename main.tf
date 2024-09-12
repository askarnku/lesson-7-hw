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


