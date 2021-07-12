provider "aws" {
    region = var.region
}


module "delete_default_vpc" {
    source = "./modules/default_vpc"

    region = var.region
    vpc_id = var.vpc_id
    vpc_cidr = var.vpc_cidr
    subnets_cidr = var.subnets_cidr
}

module "cloudwatch_alarms" {
    source = "./modules/cloudwatch"
}