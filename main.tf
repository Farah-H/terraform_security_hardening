provider "aws" {
    region = var.region
}

module "delete_default_vpc" {
    source = "./modules/default_vpc"
    
    region = var.region
    vpc_cidr = var.vpc_cidr
    subnets_cidr = var.subnets_cidr
}

# module "cloudwatch_alarms" {
#     source = "./modules/cloudwatch"

#     kms_key = module.cloudtrail_logging.kms_key
# }

module "cloudtrail_logging" {
    source = "./modules/cloudtrail"
    # cloudwatch_log_group = module.cloudwatch_alarms.cloudwatch_log_group
}

