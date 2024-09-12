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

  subnet_id  = module.subnets.public_subnet_id[0]
  nat_gw_tag = "hw7_nat"
}
