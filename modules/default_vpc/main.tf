# dependencies must be deleted first
# delete igw
resource "aws_internet_gateway" "default" {
    count = 0
}

# this resource allows import of existing subnets so that terraform can manage them
# it is dynamic because number of subnets varies per region (up to 6)
# resource "aws_subnet" "default" {
#     count = length(var.subnets_cidr)
#     vpc_id = var.vpc_id
#     cidr_block = var.subnets_cidr[count.index]
# }
# can't get the above to work (requires terraform destroy which would ruin the rest of the architecture), doing it the long way for now. 

resource "aws_subnet" "default_1" {
    count = 0
    vpc_id = var.vpc_id
    cidr_block = var.subnets_cidr[0]
}

resource "aws_subnet" "default_2" {
    count = 0
    vpc_id = var.vpc_id
    cidr_block = var.subnets_cidr[1]
}

resource "aws_subnet" "default_3" {
    count = 0
    vpc_id = var.vpc_id
    cidr_block = var.subnets_cidr[2]
}

resource "aws_subnet" "default_4" {
    count = 0
    vpc_id = var.vpc_id
    cidr_block = var.subnets_cidr[3]
}

resource "aws_subnet" "default_5" {
    count = 0
    vpc_id = var.vpc_id
    cidr_block = var.subnets_cidr[4]
}

resource "aws_subnet" "default_6" {
    count = 0
    vpc_id = var.vpc_id
    cidr_block = var.subnets_cidr[5]
}

# finally, delete vpc (this will delete remaining architecture)
resource "aws_vpc" "default" {
    count = 0
    cidr_block = var.vpc_cidr
}
